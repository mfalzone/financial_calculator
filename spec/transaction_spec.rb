require_relative 'spec_helper'

describe "Transaction" do
  describe '#inspect' do
    let(:amount) { D('100.00') }
    let(:payment) { Transaction.new(amount) }

    subject { payment.inspect }

    it { is_expected.to be_a String }
    it { is_expected.to include "Transaction" }
    it { is_expected.to include amount.to_s }
  end
end