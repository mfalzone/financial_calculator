require_relative 'spec_helper'

describe "Xirr" do
  let(:flows) { [-10, 20, 30, 40] }
  let(:dates) do
    [
      Date.new(2018, 1, 1),
      Date.new(2018, 6, 1),
      Date.new(2018, 9, 1),
      Date.new(2018, 12, 1)
    ]
  end

  describe '::with_transactions' do
    let(:transactions) do 
      flows.zip(dates).map { |flow_and_date| Transaction.new(flow_and_date[0], date: flow_and_date[1]) }
    end

    subject { Xirr.with_transactions(transactions) }

    it 'returns an Xirr object' do
      expect(subject).to be_a Xirr 
    end

    context 'the array contains objects other than Transaction' do
      let(:transactions) { flows }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe '#result' do
    subject { Xirr.new(flows, dates).result }

    it { is_expected.to be_a DecNum }

    context 'when all values are positive' do
      let(:flows) { [10, 20, 30, 40] }
      let(:flows) { [10, 20, 30, 40] }
      it_behaves_like 'the values do not converge'
    end

    context 'when all values are negative' do
      let(:flows) { [-10, -20, -30, -40] }
      it_behaves_like 'the values do not converge'
    end

    context 'when the leading value is zero' do
      describe 'all other values are positive' do
        let(:flows) { [0, 10, 20, 30] }
        it_behaves_like 'the values do not converge'
      end

      describe 'all other values are negative' do
        let(:flows) { [0, -10, -20, -30] }
        it_behaves_like 'the values do not converge'
      end
    end
  end

  describe '#inspect' do
    let(:xirr) { Xirr.new(flows, dates) }
    subject { xirr.inspect }

    it { is_expected.to include 'Xirr' }

    it 'includes the result of the calculation' do
      expect(subject).to include xirr.result.to_s
    end
  end
end