require_relative './mixins/format_helper'

# Rocket class represents a rocket object and is responsible for maintaining
# rocket attributes, calculating stats at different times of flight, and reporting status.

class Rocket
  attr_reader :fuel_burned, :flight_time, :distance_traveled

  include FormatHelper

  # These values are captured as constants since they do not change for a mission at this time.
  # In future iterations, these could be initialized with different values in the initialize method.
  PAYLOAD = 50_000
  FUEL = 1_514_100
  BURN_RATE = 168_233
  AVERAGE_SPEED = 1_500

  def initialize
    @fuel_burned = 0
    @flight_time = 0
    @distance_traveled = 0
    @exploded = false
  end

  def calculate_stats_for_elapsed_time(time) # Parameter should be in seconds
    @flight_time += time
    @distance_traveled += ( AVERAGE_SPEED.to_f / 3600) * time
    @fuel_burned += (BURN_RATE.to_f / 60) * time
  end

  def report_status
    puts "Mission status:
          Current distance traveled: #{@distance_traveled} km
          Elapsed time: #{format_time(@flight_time)}
          Fuel burned: #{format_number(@fuel_burned)} liters
          Fuel remaining: #{format_number(FUEL - @fuel_burned)} liters"
  end

  def exploded?
    @exploded
  end

  def explode!
    @exploded = true
    puts "A rapid unscheduled disassembly occurred! :-("
  end
end
