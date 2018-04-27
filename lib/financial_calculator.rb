require 'financial_calculator/decimal'
require 'financial_calculator/cashflows'
require 'financial_calculator/solvers/secant_solver'

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
  require 'financial_calculator/solvers/secant_solver'
end
