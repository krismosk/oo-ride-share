require_relative 'test_helper'

TEST_DATA_DIRECTORY = 'test/test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
    directory: TEST_DATA_DIRECTORY
    )
  end
  
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end
    
    it "establishes the base data structures when instantiated" do
      dispatcher = build_test_dispatcher
      [:trips, :passengers, :drivers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end
      
      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      expect(dispatcher.drivers).must_be_kind_of Array
    end
    
    it "loads the development data by default" do
      # Count lines in the file, subtract 1 for headers
      trip_count = %x{wc -l 'support/trips.csv'}.split(' ').first.to_i - 1
      
      dispatcher = RideShare::TripDispatcher.new
      
      expect(dispatcher.trips.length).must_equal trip_count
    end
  end
  
  describe "passengers" do
    describe "find_passenger method" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "throws an argument error for a bad ID" do
        expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end
      
      it "finds a passenger instance" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::Passenger
      end
    end
    
    describe "Passenger & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "accurately loads passenger information into passengers array" do
        first_passenger = @dispatcher.passengers.first
        last_passenger = @dispatcher.passengers.last
        
        expect(first_passenger.name).must_equal "Passenger 1"
        expect(first_passenger.id).must_equal 1
        expect(last_passenger.name).must_equal "Passenger 8"
        expect(last_passenger.id).must_equal 8
      end
      
      it "connects trips and passengers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.passenger).wont_be_nil
          expect(trip.passenger.id).must_equal trip.passenger_id
          expect(trip.passenger.trips).must_include trip
        end
      end
    end
  end
  
  describe "drivers" do
    describe "find_driver method" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
      end
      
      it "finds a driver instance" do
        driver = @dispatcher.find_driver(2)
        expect(driver).must_be_kind_of RideShare::Driver
      end
    end
    
    describe "Driver & Trip loader methods" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "accurately loads driver information into drivers array" do
        first_driver = @dispatcher.drivers.first
        last_driver = @dispatcher.drivers.last
        expect(first_driver.name).must_equal "Driver 1"
        expect(first_driver.id).must_equal 1
        expect(first_driver.status).must_equal :UNAVAILABLE
        expect(last_driver.name).must_equal "Driver 3"
        expect(last_driver.id).must_equal 3
        expect(last_driver.status).must_equal :AVAILABLE
      end
      
      it "connects trips and drivers" do
        dispatcher = build_test_dispatcher
        dispatcher.trips.each do |trip|
          expect(trip.driver).wont_be_nil
          expect(trip.driver.id).must_equal trip.driver_id
          expect(trip.driver.trips).must_include trip
        end
      end
    end
  end
  
  describe "Create a new trip with request_trip" do 
    before do
      @dispatcher = RideShare::TripDispatcher.new(directory: TEST_DATA_DIRECTORY)   
      @passenger_id = @dispatcher.passengers.first.id
    end
    
    it "Will create a new instance of Trip" do   
      trip = @dispatcher.request_trip(@passenger_id)
      
      expect(trip).must_be_kind_of RideShare::Trip
    end
    
    it "Will generate a new id for each new trip" do 
      passenger_id = @dispatcher.passengers.first.id
      trip = @dispatcher.request_trip(passenger_id)
      expect(trip.id).must_equal 6
    end
    
    it "Will assign a driver to the Trip" do
      trip = @dispatcher.request_trip(@passenger_id)
      expect(trip.driver).must_be_kind_of RideShare::Driver
    end
    
    it "Will choose the first driver who's status is available" do
      trip = @dispatcher.request_trip(@passenger_id)
      expect(trip.driver.id).must_equal 2
    end
    
    it "Will return nil if there's no available drivers" do
      dispatcher = RideShare::TripDispatcher.new(
      directory: 'test/test_data2'
      )
      
      expect { dispatcher.request_trip(@passenger_id) }.must_raise ArgumentError
    end
    
    it "Will change the Driver's status to unavailable" do 
      trip = @dispatcher.request_trip(@passenger_id)
      expect(trip.driver.status).must_equal :UNAVAILABLE
    end 
    
    it "Will add the new trip to the Driver's list of trips" do
      trip = @dispatcher.request_trip(@passenger_id)
      expect(trip.driver.trips).must_include trip
    end
    
    it "Won't create a trip if the passenger_id doesn't match to any existing passenger" do 
      expect do
        @dispatcher.request_trip(980999999999999)
      end.must_raise ArgumentError 
    end
    
    it "Will add the new trip to the Passenger's list of trips" do
      trip = @dispatcher.request_trip(@passenger_id)
      updated_trip_list = trip.passenger.add_trip(trip)
      expect(updated_trip_list).must_include trip
    end 
    
    it "Will add the newly created trip to the collection of all Trips in TripDispatcher" do
      trip = @dispatcher.request_trip(@passenger_id)
      expect(@dispatcher.trips).must_include trip
    end 
  end
end

