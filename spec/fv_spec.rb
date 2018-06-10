require_relative 'spec_helper'

describe "Fv" do
  let(:rate)              { 0.1 }
  let(:num_periods)       { 10 }
  let(:payment)           { -100 }
  let(:present_value)     { 0 }
  let(:pays_at_beginning) { false }
  let(:future_value)      { Fv.new(rate, num_periods, payment) }
  
  subject { future_value }

  it 'has a rate attribute' do
    expect(subject).to have_attributes(rate: rate)
  end

  it 'has a num_periods attribute' do
    expect(subject).to have_attributes(num_periods: num_periods)
  end

  it 'has a payment attribute' do
    expect(subject).to have_attributes(payment: payment)
  end

  it 'has a present_value attribute that defaults to 0' do
    expect(subject).to have_attributes(present_value: 0)
  end

  it 'has a pays_at_beginning? attribute that defaults to false' do
    expect(subject).to have_attributes(pays_at_beginning?: false)
  end

  it 'has a result attribute whose value is positive' do
    expect(subject).to have_attributes(result: (a_value > 0))
  end

  context 'when the payment is positive' do
    let(:payment) { 100 }

    it 'has a result attribute whose value is negative' do
      expect(subject).to have_attributes(result: (a_value < 0))
    end
  end

  context 'when the payment is 0' do
    let(:payment) { 0 }

    it 'has a future value of 0' do
      expect(subject.result).to eql Flt::DecNum(0)
    end
  end

  context 'when the number of periods is negative' do
    let(:num_periods) { -1 }
    it_behaves_like 'it has invalid arguments'
  end

  context 'when rate is non-numeric' do
    let(:rate) { 'string' }
    it_behaves_like 'it has invalid arguments'
  end

  context 'when num_periods is non-numeric' do
    let(:num_periods) { 'string' }
    it_behaves_like 'it has invalid arguments'
  end

  context 'when payment is non-numeric' do
    let(:payment) { 'string' }
    it_behaves_like 'it has invalid arguments'
  end

  context 'when present_value is non-numeric' do
    let(:present_value) { 'string' }
    
    subject { Fv.new(rate, num_periods, payment, future_value) }

    it_behaves_like 'it has invalid arguments'
  end

  context 'when the number of periods is 0' do
    let(:num_periods) { 0 }

    it 'has a result equal to the present value' do
      expect(subject.result).to eql Flt::DecNum(present_value.to_s)
    end
  end

  context 'when provided with a present value' do
    let(:present_value) { 100 }

    subject { Fv.new(rate, num_periods, payment, present_value) }

    it { is_expected.to have_attributes(present_value: present_value) }
  end

  context 'when payments occur at the beginning of each period' do
    let(:pays_at_beginning) { true }

    subject { Fv.new(rate, num_periods, payment, 0, pays_at_beginning) }

    it { is_expected.to have_attributes(pays_at_beginning?: true) }
  end

  describe '#inspect' do

    subject { future_value.inspect }

    it { is_expected.to be_a String }
    it { is_expected.to include 'FV' }
    it 'includes the result of the future value calculation' do
      expect(subject).to include future_value.result.to_s
    end
  end

  describe '#result' do
    subject { future_value.result }

        it { is_expected.to be_a Flt::DecNum }
  end
end