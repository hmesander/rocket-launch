require_relative '../lib/rocket'

RSpec.describe Rocket do
  let(:subject) { Rocket.new }

  describe '#initialize' do
    it 'initializes Rocket with expected attributes' do
      expect(subject).to be_an_instance_of(Rocket)
      expect(subject.fuel_burned).to eq(0)
      expect(subject.distance_traveled).to eq(0)
      expect(subject.flight_time).to eq(0)
      expect(subject.instance_variable_get(:@exploded)).to eq(false)
    end
  end

  describe '#calculate_stats_for_elapsed_time' do
    it 'adds given time to flight_time' do
      expect{ subject.calculate_stats_for_elapsed_time(30)}.to change(subject, :flight_time).by(30)
    end

    it 'calculates the distance traveled and adds value to distance_traveled' do
      additional_distance_traveled = ( Rocket::AVERAGE_SPEED.to_f / 3600) * 30
      expect{ subject.calculate_stats_for_elapsed_time(30)}.to change(subject, :distance_traveled).by(additional_distance_traveled)
    end

    it 'calculates the fuel burned and adds value to fuel_burned' do
      additional_fuel_burned = (Rocket::BURN_RATE.to_f / 60) * 30
      expect{ subject.calculate_stats_for_elapsed_time(30)}.to change(subject, :fuel_burned).by(additional_fuel_burned)
    end
  end

  describe '#explode!' do
    it 'sets exploded instance variable to true' do
      expect(subject.exploded?).to eq(false)

      subject.explode!

      expect(subject.exploded?).to eq(true)
    end
  end
end