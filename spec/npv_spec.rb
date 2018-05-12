require_relative 'spec_helper'

describe "Npv" do
  let(:rate)      { 0.1 }
  let(:cashflows) { [10] * 4 }
  let(:npv)       { Npv.new(rate, cashflows) }

  subject { Npv.new(rate, cashflows) }

  it 'has a rate attribute' do
    expect(subject).to have_attributes(rate: rate)
  end

  it 'has an cashflows attribute' do
    expect(subject).to have_attributes(cashflows: cashflows)
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
    subject { npv.inspect }

    it { is_expected.to be_a String }
    it { is_expected.to include 'NPV' }
    it 'includes the result of the Npv calculation' do
      expect(subject).to include npv.result.to_s
    end
  end
end