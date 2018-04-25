require 'financial_calculator/decimal'
require 'financial_calculator/cashflows'

# The *FinancialCalculator* module adheres to the following conventions for
# financial calculations:
#
#  * Positive values represent cash inflows (money received); negative
#    values represent cash outflows (payments).
#  * *principal* represents the outstanding balance of a loan or annuity.
#  * *rate* represents the interest rate _per period_.
module FinancialCalculator
  autoload :Amortization, 'financial_calculator/amortization'
  autoload :Rate,         'financial_calculator/rates'
  autoload :Transaction,  'financial_calculator/transaction'
end
