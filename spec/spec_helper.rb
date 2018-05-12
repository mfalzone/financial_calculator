require 'simplecov'
require 'coveralls'

# Coveralls.wear!
SimpleCov.start do
  add_filter "/spec/"
  minimum_coverage 100
end

require 'active_support/all'

require 'pry'

require 'flt'
require 'flt/d'

require_relative '../lib/financial_calculator'
include FinancialCalculator

shared_examples_for 'the values do not converge' do
  it 'should raise an ArgumentError' do
    expect { subject }.to raise_error ArgumentError
  end
end