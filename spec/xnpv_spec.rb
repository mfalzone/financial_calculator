require_relative 'spec_helper'

describe "Xnpv" do
  let(:cashflows) { [1000] * 5 }
  let(:year)      { 2017 }
  let(:rate)      { 0.02 }
  let(:xnpv)      { Xnpv.new(rate, cashflows, dates) }
  let(:dates) do
    [
      Date.new(year, 1, 1),
      Date.new(year, 3, 1),
      Date.new(year, 6, 1),
      Date.new(year, 6, 15),
      Date.new(year, 6, 30)
    ]
  end

  subject { xnpv }

  it 'has a cashflows property' do
    expect(subject).to have_attributes(cashflows: cashflows)
  end
  
  it 'has a rate property' do
    expect(subject).to have_attributes(rate: rate)
  end

  it 'has a dates property' do
    expect(subject).to have_attributes(dates: dates)
  end

  it 'has a result property' do
    expect(subject.result).to be_a Flt::DecNum
  end
  
  context 'when dates and cashflows are not the same size' do
    let(:transactions) { cashflows[1..-1] }
    
    subject { Xnpv.new(rate, transactions, dates) }

    it 'raises an ArgumentError' do
      expect { subject }.to raise_error ArgumentError
    end
  end

  context 'when the dates array does not contain only dates' do
    let(:dates) { [Date.today] * 4 + [1] }

    it 'raises an ArgumentError' do
      expect { subject }.to raise_error ArgumentError
    end
  end

  describe '::with_transactions' do
    let(:transactions) { dates.map { |date| Transaction.new(1000, date: date) } } 

    subject { Xnpv.with_transactions(rate, transactions) }

    it 'returns an Xnpv object' do
      expect(subject).to be_a Xnpv
    end

    context 'the array contains objects other than Transaction' do
      let(:transactions) { cashflows }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe '#inspect' do
    subject { xnpv.inspect }

    it { is_expected.to include 'XNPV' }

    it 'includes the result of the calculation' do
      expect(subject).to include xnpv.result.to_s
    end
  end
end