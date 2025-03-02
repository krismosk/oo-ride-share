require_relative 'test_helper'

describe "Trip class" do
  describe "initialize" do
    before do
      start_time = Time.parse('2015-05-20T12:14:00+00:00')
      end_time = start_time + 25 * 60
      @trip_data = {
      id: 8,
      driver: RideShare::Driver.new(id: 54, name: "Test Driver", vin: "12345678901234567", status: :AVAILABLE),
      passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"),
      start_time: start_time,
      end_time: end_time,
      cost: 23.45,
      rating: 3
    }
    @trip = RideShare::Trip.new(@trip_data)
  end
  
  it "raises and error for end_time being earlier than start_time" do 
    start_time = Time.parse('2015-05-20T12:14:00+00:00')
    end_time = Time.parse('2015-05-20T11:14:00+00:00')
    @time_checking_trip_data = {
    id: 8,
    driver: RideShare::Driver.new(id: 54, name: "Test Driver", vin: "12345678901234567", status: :AVAILABLE),
    passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"), 
    start_time: start_time, 
    end_time: end_time, 
    cost: 23.45, 
    rating: 3
  }
  
  expect do
    RideShare::Trip.new(@time_checking_trip_data)
  end.must_raise ArgumentError
end

it "is an instance of Trip" do
  expect(@trip).must_be_kind_of RideShare::Trip
end

it "stores an instance of passenger" do
  expect(@trip.passenger).must_be_kind_of RideShare::Passenger
end

it "stores an instance of driver" do
  expect(@trip.driver).must_be_kind_of RideShare::Driver
end

it "raises an error for an invalid rating" do
  [-3, 0, 6].each do |rating|
    @trip_data[:rating] = rating
    expect do
      RideShare::Trip.new(@trip_data)
    end.must_raise ArgumentError
  end
end
end

describe "#calculate_duration" do
describe "when start_time and end_time are present" do
  it "Returns the trip duration in seconds" do 
    trip_data = {
    id: 8, 
    driver: RideShare::Driver.new(id: 54, name: "Test Driver", vin: "12345678901234567", status: :AVAILABLE),
    passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"), 
    start_time: Time.parse("2015-05-20T12:14:00+00:00"), 
    end_time: Time.parse("2015-05-20T12:44:00+00:00"), 
    cost: 23.45, 
    rating: 3
  }
  trip = RideShare::Trip.new(trip_data)
  
  expect(trip.calculate_duration).must_equal 1800.0
end
end

describe "when end_time is nil" do
  it "Returns nil" do
    trip_data = {
    id: 8, 
    driver: RideShare::Driver.new(id: 54, name: "Test Driver", vin: "12345678901234567", status: :AVAILABLE),
    passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone_number: "412-432-7640"), 
    start_time: Time.parse("2015-05-20T12:14:00+00:00"), 
    end_time: nil, 
    cost: 23.45, 
    rating: 3
  }
  trip = RideShare::Trip.new(trip_data)
  expect(trip.calculate_duration).must_equal 0
end 
end
end
end





