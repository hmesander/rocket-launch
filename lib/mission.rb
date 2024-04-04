require_relative 'rocket'
require_relative './mixins/format_helper'

# Mission class is responsible for planning a mission, launching a mission,
# tracking mission stats, and summarizing a mission.

class Mission
  attr_reader :name, :abort_count, :retry_count, :rocket

  include FormatHelper

  # These values are captured as constants since they do not change for a mission at this time.
  # In future iterations, these could be initialized with different values in the initialize method.
  MISSION_DISTANCE = 160
  REPORT_INTERVAL = 30

  def initialize
    @name = nil
    @rocket = Rocket.new
    @abort_count = 0
    @retry_count = 0
    @random_seed = Random.new_seed
  end

  def print_plan
    puts "Mission plan:
      Travel distance:  #{MISSION_DISTANCE} km
      Payload capacity: #{format_number(Rocket::PAYLOAD)} kg
      Fuel capacity:    #{format_number(Rocket::FUEL)} liters
      Burn rate:        #{format_number(Rocket::BURN_RATE)} liters/min
      Average speed:    #{format_number(Rocket::AVERAGE_SPEED)} km/h
      Random seed:      #{@random_seed}"
  end

  def prompt_for_mission_name
    print "What is the name of this mission? "
    @name = gets.chomp
  end

  def launch
    puts "Launched!"

    until @rocket.distance_traveled >= MISSION_DISTANCE || @rocket.exploded?
      sleep(REPORT_INTERVAL)
      @rocket.calculate_stats_for_elapsed_time(REPORT_INTERVAL)
      @rocket.explode! if randomly_explode?
      @rocket.report_status
    end

    print_summary
  end

  def record_abort_and_retry
    @abort_count += 1
    @retry_count += 1
  end

  def randomly_abort?
    [*1..3].sample(random: Random.new(@random_seed)) == 1
  end

  def reset_seed
    @random_seed = Random.new_seed
  end

  private

  def print_summary
    puts "Mission summary:
          Total distance traveled: #{@rocket.distance_traveled} km
          Number of abort and retries: #{@abort_count}/#{@retry_count}
          Number of explosions: #{@rocket.exploded? ? 1 : 0}
          Total fuel burned: #{format_number(@rocket.fuel_burned)} liters
          Flight time: #{format_time(@rocket.flight_time)}"
  end

  def randomly_explode?
    [*1..5].sample(random: Random.new(@random_seed)) == 1
  end
end
