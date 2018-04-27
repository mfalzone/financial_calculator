module FinancialCalculator
  # Class for calculating internal rate of return of a series of cash flows
  class IRR
    # Creates a new IRR instance using the cashflows and an optional guess
    def initialize(cashflows, guess = 0)
      @solver = FinancialCalculator::IRR::SecantSolver
    end
  end
end

