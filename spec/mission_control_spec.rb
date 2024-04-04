require_relative '../lib/mission_control'

RSpec.describe MissionControl do
  let(:subject) { MissionControl.new }

  describe '#initialize' do
    it 'initializes MissionControl with an empty array of missions and playing = true' do
      expect(subject).to be_an_instance_of(MissionControl)
      expect(subject.instance_variable_get(:@missions)).to be_an_instance_of(Array)
      expect(subject.instance_variable_get(:@missions).empty?).to be_truthy
      expect(subject.instance_variable_get(:@playing)).to eq(true)
    end
  end

  describe '#start' do
    context 'while @playing is true' do # default behavior
      it 'begins a new mission' do
        expect(subject).to receive(:gets).and_return("n")  # for "begin another mission" prompt
        expect(subject).to receive(:start_mission).and_return(true)

        subject.start
      end

      it 'records the mission to mission control' do
        expect(subject).to receive(:gets).and_return("n")  # for "begin another mission" prompt
        expect(subject).to receive(:start_mission).and_return(true)

        expect{ subject.start }.to change(subject.missions, :count).by(1)
      end
    end

    context 'when @playing is false' do
      before { subject.playing = false }

      it 'does not begin a new mission' do
        expect(subject).to_not receive(:gets)  # for "begin another mission" prompt
        expect(subject).to_not receive(:start_mission)

        subject.start
      end
    end
  end

  describe '#start_mission' do
    let(:mission) { Mission.new }

    before do
      allow(mission).to receive(:gets).and_return("Minerva")  # for "mission name" prompt
      allow(subject).to receive(:gets).and_return("Y")  # for stage prompts
      allow(subject).to receive(:proceed?).and_return(true)
      allow(subject).to receive(:manually_abort?).and_return(false)
      allow(mission).to receive(:randomly_abort?).and_return(false)
      allow(subject).to receive(:ready_to_launch?).and_return(true)
    end

    context 'when all pre-launch checks pass' do
      it 'calls mission#launch to launch the rocket' do
        expect(mission).to receive(:launch)

        subject.send(:start_mission, mission)
      end
    end

    context 'when proceed? check does not pass' do
      it 'does not call mission#launch to launch the rocket' do
        allow(subject).to receive(:proceed?).and_return(false)

        expect(mission).to_not receive(:launch)

        subject.send(:start_mission, mission)
      end
    end

    context 'when ready_to_launch? check does not pass' do
      it 'does not call mission#launch to launch the rocket' do
        allow(subject).to receive(:ready_to_launch?).and_return(false)

        expect(mission).to_not receive(:launch)

        subject.send(:start_mission, mission)
      end
    end

    context 'when mission is manually aborted' do
      it 'calls #restart_mission to retry the mission' do
        allow(subject).to receive(:manually_abort?).and_return(true)

        expect(subject).to receive(:restart_mission)

        subject.send(:start_mission, mission)
      end
    end

    context 'when mission is randomly aborted' do
      it 'calls #restart_mission to retry the mission' do
        allow(mission).to receive(:randomly_abort?).and_return(true)

        expect(subject).to receive(:restart_mission)

        subject.send(:start_mission, mission)
      end
    end
  end
end
