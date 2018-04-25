require_relative '../spec_helper'

describe "Payment" do
  describe '#inspect' do
    let(:amount) { D('100.00') }
    let(:payment) { Payment.new(amount) }

    subject { payment.inspect }

    it { is_expected.to be_a String }
    it { is_expected.to include "Payment" }
    it { is_expected.to include amount.to_s }
  end
end