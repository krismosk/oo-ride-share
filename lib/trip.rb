require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :driver, :driver_id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating
    
    def initialize(id:, driver: nil, driver_id: nil, passenger: nil, passenger_id: nil, start_time:, end_time:, cost: nil, rating:)
      super(id)
      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else 
        raise ArgumentError, "Driver or driver_id is required"
      end
      
      if passenger
        @passenger = passenger
        @passenger_id = passenger.id
      elsif passenger_id
        @passenger_id = passenger_id
      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end
      
      if start_time != nil && end_time != nil
        if end_time < start_time 
          raise ArgumentError.new("#{end_time} is the same time as #{start_time}")
        end
        
        @start_time = start_time
        @end_time = end_time
      end 
      
      @cost = cost
      @rating = rating
      
      if rating != nil
        if @rating > 5 || @rating < 1
          raise ArgumentError.new("Invalid rating #{@rating}")
        end
      end
    end
    
    def calculate_duration
      return 0 if end_time.nil?
      end_time - start_time
    end
    
    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "DriverID=#{driver&.id.inspect}>" +
      "PassengerID=#{passenger&.id.inspect}>"
    end
    
    def connect(driver, passenger)
      @passenger = passenger
      passenger.add_trip(self)
      
      @driver = driver
      driver.add_trip(self)
    end
    
    private
    
    def self.from_csv(record)
      return self.new(
      id: record[:id],
      driver_id: record[:driver_id],
      passenger_id: record[:passenger_id],
      start_time: Time.new(record[:start_time]),
      end_time: Time.new(record[:end_time]),
      cost: record[:cost],
      rating: record[:rating]
      )
    end
    
  end
end
