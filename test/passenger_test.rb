require_relative 'test_helper'

describe "Passenger class" do
  
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end
    
    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end
    
    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end
      
      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end
  
  
  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone_number: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new(id: 8, passenger: @passenger, start_time: Time.parse("2016-08-08"), end_time: Time.parse("2016-08-09"), rating: 5)
      
      @passenger.add_trip(trip)
    end
    
    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end
    
    # it "all Trips must have the same passenger's passenger id" do
    #   @passenger.trips.each do |trip|
    #     expect(trip.passenger.id).must_equal 9
    #   end
    # end
  end
  
  describe "net_expenditures" do
    it "Will return total amount a passenger spent on their trips taken" do
      # Arrange
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
      trip1 = RideShare::Trip.new(id: 8, passenger: @passenger, start_time: Time.parse("2016-08-08"), end_time: Time.parse("2016-08-09"), cost: 2, rating: 5)
      trip2 = RideShare::Trip.new(id: 9, passenger: @passenger, start_time: Time.parse("2016-08-10"), end_time: Time.parse("2016-08-11"), cost: 10, rating: 4)
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      # p @passenger.trips.length
      
      trip_costs = []
      trip_costs << @passenger.trips[0].cost
      trip_costs << @passenger.trips[1].cost
      
      total_cost = trip_costs.sum
      p total_cost
      # Act
      
      # Assert
      expect(total_cost).must_equal 12
      
    end
    
    
    
  end
end
