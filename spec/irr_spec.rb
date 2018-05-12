require_relative 'spec_helper'

describe "Irr" do
  let(:flows) { [-10, 20, 30, 40] }
  let(:irr)   { Irr.new(flows) }

  describe '#result' do
    subject { irr.result }

    it { is_expected.to be_a Flt::DecNum }

    context 'when all values are positive' do
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

    describe '#inspect' do
      subject { irr.inspect }

      it { is_expected.to be_a String }
      it { is_expected.to include 'Irr' }

      it 'includes the result of the calculation' do
        expect(subject).to include irr.result.to_s
      end
    end
  end
end