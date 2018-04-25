require_relative 'spec_helper'

shared_examples_for 'the values do not converge' do
  it 'should raise an ArgumentError' do
    expect { subject }.to raise_error ArgumentError
  end
end

describe "Cashflows" do
  let(:transactions)  do
    [
      Transaction.new(-1000, :date => Time.new(1985, 1, 1)),
      Transaction.new(  600, :date => Time.new(1990, 1, 1)),
      Transaction.new(  600, :date => Time.new(1995, 1, 1))
    ]
  end

  describe '#irr' do
    let(:flows)  { [-4000, 1200, 1410, 1875, 1050] }
    
    subject { flows.irr.round(3) }

    it { is_expected.to eql D('0.143') }

    context 'when called on an array of Transactions' do
      let(:flows) { transactions }

      it 'should raise a NoMethodError' do
        expect { subject }.to raise_error NoMethodError
      end
    end

    context 'when the values do not converge' do
      let(:flows) { [10, 20, 30] }
      it_behaves_like 'the values do not converge'
    end
  end

  describe '#npv' do
    let(:flows) { [-100.0, 60, 60, 60] }

    subject { flows.npv(0.1).round(3) }

    it { is_expected.to eql D('49.211') }
  end

  describe '#xirr' do
    let(:xirr_transactions) { transactions }

    subject { xirr_transactions.xirr.effective.round(6) }

    it { is_expected.to eql D('0.024851') }
    
    context 'when the values do not converge' do
      let(:xirr_transactions) { transactions[1,3] }

      it_behaves_like 'the values do not converge'
    end
  end

  describe '#xnpv' do
    subject { transactions.xnpv(0.6).round(2) }

    it { is_expected.to eql -937.41 }
  end
end
