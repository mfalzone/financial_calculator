require_relative 'spec_helper'

describe "Irr" do
  let(:flows) { [-10, 20, 30, 40] }

  describe '#result' do
    subject { Irr.new(flows).result }

    it { is_expected.to be_a DecNum }

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
  end
end