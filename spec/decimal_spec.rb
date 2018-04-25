require_relative 'spec_helper'
require_relative '../lib/financial_calculator/decimal.rb'

describe "Numeric" do
  let(:dec_num) { D('12.123') }

  subject { dec_num }

  describe 'it converts to a BigDecimal' do
    subject { dec_num.convert_to BigDecimal }

    it { is_expected.to be_a BigDecimal }
  end

  describe '#to_d' do
    context 'when already a Flt::DecNum' do
      let(:dec_num) { D('12.123') }

      subject { dec_num.to_d }

      it { is_expected.to be_a Flt::DecNum }
    end
  end
end
