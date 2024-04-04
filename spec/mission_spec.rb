require_relative '../lib/mission'
require_relative '../lib/rocket'

RSpec.describe Mission do
  let(:subject) { Mission.new }

  describe '#initialize' do
    it 'initializes Mission with expected attributes' do
      expect(subject).to be_an_instance_of(Mission)
      expect(subject.name).to be_nil
      expect(subject.abort_count).to eq(0)
      expect(subject.retry_count).to eq(0)
      expect(subject.rocket).to be_an_instance_of(Rocket)
      expect(subject.instance_variable_get(:@random_seed)).to be_an_instance_of(Integer)
    end
  end

  describe '#record_abort_and_retry' do
    it 'increments the abort_count and retry_count attributes' do
      expect{ subject.record_abort_and_retry }.to change(subject, :abort_count).by(1)
      expect{ subject.record_abort_and_retry }.to change(subject, :retry_count).by(1)
    end
  end

  describe '#reset_seed' do
    it 'resets the seed to another value to avoid a repeating abort loop' do
      original_seed = subject.instance_variable_get(:@random_seed)

      subject.reset_seed

      expect(subject.instance_variable_get(:@random_seed)).to_not eq(original_seed)
    end
  end

  describe 'format helpers' do
    before { subject.extend(FormatHelper) }

    describe '#format_number' do
      it 'should format the integer or float with commas to be more human readable' do
        expect(subject.format_number(1_300_000)).to eq('1,300,000')
      end
    end

    describe '#format_time' do
      it 'should format the time in seconds as H:MM:SS to be more human readable' do
        expect(subject.format_time(210)).to eq('0:03:30')
      end
    end
  end
end
