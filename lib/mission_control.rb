require_relative 'mission'

# MissionControl class is responsible for managing the flow of launch stages, starting missions,
# tracking stats for multiple missions, and displaying the final mission summary.

class MissionControl
  attr_reader :missions # for testing purposes
  attr_accessor :playing # for testing purposes

  include FormatHelper

  def initialize
    @missions = Array.new
    @playing = true
  end

  def start
    puts 'Welcome to Mission Control!'

    while @playing do
      mission = Mission.new
      start_mission(mission)

      @missions << mission

      print "Would you like to run another mission? (Y/n) "
      continue = gets.chomp.downcase
      @playing = false if continue == 'n'
    end

    print_final_summary
  end

  private

  def start_mission(mission)
    mission.print_plan
    mission.prompt_for_mission_name if mission.name.nil?

    return unless proceed?
    return unless engage_afterburner?

    if manually_abort? || mission.randomly_abort?
      restart_mission(mission)
      return
    end

    return unless ready_to_launch?

    mission.launch
  end

  def print_final_summary
    puts "Mission final summary:
          Total distance traveled: #{@missions.map(&:rocket).sum(&:distance_traveled)} km
          Total number of abort and retries: #{@missions.sum(&:abort_count)}/#{@missions.sum(&:retry_count)}
          Total number of explosions: #{@missions.map(&:rocket).select { |rocket| rocket.exploded? }.length}
          Total fuel burned: #{format_number(@missions.map(&:rocket).sum(&:fuel_burned))} liters
          Total flight time: #{format_time(@missions.map(&:rocket).sum(&:flight_time))}"
  end

  def restart_mission(mission)
    puts "Mission aborted! Restarting mission..."
    mission.record_abort_and_retry
    mission.reset_seed
    start_mission(mission)
  end

  def proceed?
    print "Would you like to proceed? (Y/n) "
    proceed = gets.chomp.downcase
    proceed == 'y'
  end

  def manually_abort?
    print "Abort mission? (Y/n) "
    abort = gets.chomp.downcase
    abort == 'y'
  end

  def ready_to_launch?
    release_support_structures? && perform_cross_checks?
  end

  def engage_afterburner?
    print "Engage afterburner? (Y/n) "
    afterburner = gets.chomp.downcase
    afterburner == 'y'
  end

  def release_support_structures?
    print "Release support structures? (Y/n) "
    release = gets.chomp.downcase
    release == 'y'
  end

  def perform_cross_checks?
    print "Perform cross-checks? (Y/n) "
    cross_checks = gets.chomp.downcase
    cross_checks == 'y'
  end
end
