require_relative 'spec_helper'

describe "Nper" do
  let(:rate)          { 0.1 }
  let(:payment)       { 4500 }
  let(:present_value) { 0 }
  let(:future_value)  { 0 }
  let(:nper)          { Nper.new(rate, payment, present_value, future_value) }

  subject { Nper.new(rate, payment, present_value, future_value) }

  it 'has a rate attribute' do
    expect(subject).to have_attributes(rate: rate)
  end

  it 'has a payment attribute' do
    expect(subject).to have_attributes(payment: payment)
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

  context 'when provided a non-numeric rate' do
    let(:rate) { 'string' }

    it 'raises an ArgumentError' do
      expect { subject }.to raise_error ArgumentError
    end
  end

  describe '#inspect' do
    subject { nper.inspect }

    it { is_expected.to be_a String }
    it { is_expected.to include 'NPER' }
    it 'includes the result of the Nper calculation' do
      expect(subject).to include nper.result.to_s
    end
  end
end