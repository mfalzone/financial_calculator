require 'flt'
require 'flt/d'
# The *FinancialCalculator* module adheres to the following conventions for
# financial calculations:
#
#  * Positive values represent cash inflows (money received); negative
#    values represent cash outflows (payments).
#  * *principal* represents the outstanding balance of a loan or annuity.
#  * *rate* represents the interest rate _per period_.
module FinancialCalculator
  require 'financial_calculator/amortization'
  require 'financial_calculator/rates'
  require 'financial_calculator/transaction'
  require 'financial_calculator/irr'
  require 'financial_calculator/pv'
  require 'financial_calculator/npv'
  require 'financial_calculator/xnpv'
  require 'financial_calculator/xirr'
end
