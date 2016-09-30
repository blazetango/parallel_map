# frozen_string_literal: true
require 'spec_helper'

describe ParallelMap do
  let(:count) { ENV.fetch('SPEC_COUNT', '4').to_i }
  let(:basic_range) { (1..count) }

  let(:plus_one) { proc { |x| x + 1 } }
  let(:delay) { 0.5 }
  let(:sleepy_plus_one) { proc { |x| sleep(delay) && plus_one.call(x) } }

  let(:serial_time) { Benchmark.realtime { subject.map(&sleepy_plus_one) } }
  let(:parallel_time) { Benchmark.realtime { subject.pmap(&sleepy_plus_one) } }

  shared_examples 'a parallel mapping enumerable' do
    before(:each) { ParallelMap.patch subject.class }
    context 'with no proc given' do
      it 'returns self' do
        expect(subject.pmap.to_a).to eq subject.to_a
      end
    end
    context 'with proc given' do
      it 'returns results correctly' do
        expect(subject.pmap(&plus_one)).to eq subject.map(&plus_one)
      end
      it 'takes less time' do
        report_gain subject, count, serial_time, parallel_time
        expect(parallel_time).to be < serial_time
      end
    end
  end
  context '#pmap' do
    context 'with Range' do
      subject { basic_range }
      it_behaves_like 'a parallel mapping enumerable'
    end
    context 'with Array' do
      subject { basic_range.to_a }
      it_behaves_like 'a parallel mapping enumerable'
    end
  end
  context '.version' do
    it 'has a version number' do
      expect(ParallelMap::VERSION).not_to be nil
    end
  end
end
