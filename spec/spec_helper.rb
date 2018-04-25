require 'simplecov'
require 'coveralls'

Coveralls.wear!
SimpleCov.start do
  minimum_coverage 99 
end

require 'minitest/autorun'
require 'minitest/spec'

require 'active_support/all'

require 'pry'

require 'flt'
require 'flt/d'

require_relative '../lib/financial_calculator/amortization.rb'
require_relative '../lib/financial_calculator/cashflows.rb'
require_relative '../lib/financial_calculator/rates.rb'
require_relative '../lib/financial_calculator/transaction.rb'
include FinancialCalculator
