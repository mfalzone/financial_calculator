require_relative 'spec_helper'

describe "Pmt" do
  let(:rate)      { 0.1 }
  let(:present_value) { 1000 }
  let(:num_periods)       { 20 }
  let(:future_value)  { 0 }
  let(:pay_at_beginning) { false }
  let(:pmt)       { Pmt.new(rate, num_periods, present_value, future_value, pay_at_beginning) }

  subject { pmt }

  it 'has a rate attribute' do
    expect(subject).to have_attributes(rate: rate)
  end

  it 'has a num_periods attribute' do
    expect(subject).to have_attributes(num_periods: num_periods)
  end

  it 'has a present_value attribute' do
    expect(subject).to have_attributes(present_value: present_value)
  end

  it 'has a future_value attribute' do
    expect(subject).to have_attributes(future_value: future_value)
  end

  it 'has a pays_at_beginning? attribute that defaults to false' do
    expect(subject).to have_attributes(pays_at_beginning?: false)
  end

  it 'has a result attribute' do
    expect(subject.result).to be_a Numeric
  end

  context 'when payments occur at the beginning of each period' do
    let(:pay_at_beginning) { true }
    it { is_expected.to have_attributes(pays_at_beginning?: true) }
  end

  context 'when given a non-numeric rate' do
    let(:rate) { 'string' }
    it_behaves_like 'it has invalid arguments'
  end

  context 'when given a non-numeric number of periods' do
    let(:num_periods) { 'string' }
    it_behaves_like 'it has invalid arguments'
  end

  context 'when given a non-numeric present value' do
    let(:present_value) { 'string' }
    it_behaves_like 'it has invalid arguments'
  end

  context 'when give a non-numeric future value' do
    let(:future_value) { 'string' }
    it_behaves_like 'it has invalid arguments'
  end

  describe '#inspect' do
    subject { pmt.inspect }

    it { is_expected.to be_a String }
    it { is_expected.to include 'PMT' }
    it 'includes the result of the PMT calculation' do
      expect(subject).to include pmt.result.to_s
    end
  end
end