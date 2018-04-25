require_relative 'spec_helper'

shared_examples_for 'does not raise error' do
  it 'does not raise an error' do
    expect { subject }.to_not raise_error
  end
end

describe "Rates" do
  let(:test_rate)  { 0.15 }
  let(:compounding_Period) { :monthly }
  let(:type) { :nominal }
  let(:opts) { nil }
  let(:rate) { Rate.new(test_rate, type) }
  
  subject { rate }

  context 'when given a duration' do
    let(:type) { :effective }
    let(:rate) { Rate.new(test_rate, type, duration: 360) }

    subject { rate.duration }

    it { is_expected.to eql 360 }
  end

  describe 'when compared to another interest rate' do
    let(:r1) { rate }
    let(:r2) { Rate.new(compared_rate, type) }

    subject { r1 <=> r2 }

    context 'when the other rate is smaller' do
      let(:compared_rate) { test_rate - 0.01}
      it { is_expected.to eql 1 }
    end

    context 'when the other rate is the same' do
      let(:compared_rate) { test_rate }
      it { is_expected.to eql 0 }
    end

    context 'when the other rate is bigger' do
      let(:compared_rate) { test_rate + 0.01 }
      it { is_expected.to eql -1 }
      
    end
  end

  describe "should convert to a monthly value" do
    let(:type) { :effective }
    let(:test_rate) { 0.0375 }

    subject { rate.monthly }

    it { is_expected.to eql D('0.003125') }
  end

  describe 'converts effective interest rates to nominal' do
    context 'when the rates compounding period is finite' do
      subject { Rate.to_nominal(D('0.0375'), 12).round(5) }

      it { is_expected.to eql D('0.03687') }
    end

    context 'when the rate is continuously compounding' do
      subject { Rate.to_nominal(D('0.0375'), Flt::DecNum.infinity).round(5) }

      it { is_expected.to eql D('0.03681') }
    end
  end

  context 'type is an unknown value' do
    let(:type) { :foo }

    it 'should raise an ArgumentError' do
      expect { subject }.to raise_error ArgumentError
    end
  end

  context 'with compounding period' do
    let(:rate) { Rate.new(test_rate, type, compounds: compounding_period) }
    
    describe 'anually' do
      let(:compounding_period) { :annually }
      it_behaves_like 'does not raise error'
    end

    describe 'continuously' do
      let(:compounding_period) { :continuously }
      it_behaves_like 'does not raise error'
    end

    describe 'daily' do
      let(:compounding_period) { :daily }
      it_behaves_like 'does not raise error'
    end

    describe 'monthly' do
      let(:compounding_period) { :monthly }
      it_behaves_like 'does not raise error'
    end

    describe 'quarterly' do
      let(:compounding_period) { :quarterly }
      it_behaves_like 'does not raise error'
    end

    describe 'semiannually' do
      let(:compounding_period) { :semiannually }
      it_behaves_like 'does not raise error'
    end

    describe 'Numeric' do
      let(:compounding_period) { 7 }
      it_behaves_like 'does not raise error'
    end

    describe 'unknown string' do
      let(:compounding_period) { :foo }
      it 'raises an error' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe '#inspect' do
    subject { rate.inspect }

    it { is_expected.to be_a String }
    it { is_expected.to include ':apr' }
  end

  describe '#apr' do
    subject { rate.apr }

    it { is_expected.to eql rate.effective }
  end

  describe '#apy' do
    subject { rate.apy }

    it { is_expected.to eql rate.effective }
  end

  describe "#effective" do
    context 'with compounding period' do
      let(:rate) { Rate.new(test_rate, :nominal, compounds: compounding_period) }

      subject { rate.effective.round(5) }

      describe 'monthly' do
        let(:compounding_period) { :monthly }
        it { should == D('0.16075') }
      end

      describe 'annually' do
        let(:compounding_period) { :annually }
        it { should == D('0.15000') }
      end

      describe 'continuously' do
        let(:compounding_period) { :continuously }
        it { should == D('0.16183') }
      end

      describe 'daily' do
        let(:compounding_period) { :daily }
        it { should == D('0.16180') }
      end

      describe 'quarterly' do
        let(:compounding_period) { :quarterly }
        it { should == D('0.15865') }
      end

      describe 'semi-annually' do
        let(:compounding_period) { :semiannually }
        it { should == D('0.15563') }
      end

      describe 'Numeric' do
        let(:compounding_period) { 7 }
        it { should == D('0.15999') }
      end
    end
  end
end
