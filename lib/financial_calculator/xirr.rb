module FinancialCalculator
  class Xirr
    # @return [DecNum] The internal rate of return 
    # @example
    #   transactions = []
    #   transactions << Transaction.new(-1000, :date => Date.new(1985,01,01))
    #   transactions << Transaction.new(  600, :date => Date.new(1990,01,01))
    #   transactions << Transaction.new(  600, :date => Date.new(1995,01,01))
    #   Xirr.with_transactions(transactions).result #=> 0.0249 
    attr_reader :result

    # The number of iterations to perform while attempting to minimize the root.
    NUM_ITERATIONS = 1_000

    # Factory method for creating an Xirr instance from an array of transactions
    # @param [Array<Transaction>] transactions An array of transactions
    # @param [Numeric] /_1 An optional first guess to use when calculating the secant method
    # @param [Numeric] r_2 An optional second guess to use when calculating the secant method
    # @return [FinancialCalculator::Xirr] An Xirr instance 
    # @api public
    def self.with_transactions(transactions, r_1 = nil, r_2 = nil)
      unless transactions.all? { |t| t.is_a? Transaction }
        raise ArgumentError.new("Argument \"transactions\" must be an array of Transaction")
      end

      cashflows  = transactions.map(&:amount)
      dates      = transactions.map(&:date)

      self.new(cashflows, dates, r_1, r_2)
    end

    # Creates a new Xirr instance
    # @param [Array<Numeric>] cashflows An array of cash flows.
    # @param [Numeric] r_1 An optional first guess to use for the secant method.
    # @param [Numeric] r_2 An optional second guess to use for the secant method.
    # @return [FinancialClaculator::Xirr] An Xirr instance 
    # @see http://en.wikipedia.org/wiki/Internal_rate_of_return
    # @api public
    def initialize(cashflows, dates, r_1 = nil, r_2 = nil)
      unless (cashflows[0].positive? ^ cashflows[1].positive?) & cashflows[0].nonzero?
        raise ArgumentError.new('The cashflows do not converge') 
      end
      @eps = 1e-7
      @cashflows = cashflows.map { |val| Flt::DecNum(val.to_s) }
      @dates  = dates

      r_1 = r_1 ? Flt::DecNum(r_1.to_s) : initial_r_1
      r_2 = r_2 ? Flt::DecNum(r_2.to_s) : initial_r_2

      @result = solve(@cashflows, @dates, r_1, r_2)
    end

    # @return [String]
    # @api public
    def inspect
      "Xirr(#{@result})"
    end

    private

    # Perform a single iteration
    # @param [Array<Numeric>] cashflows
    # @param [Numeric] r_1
    # @param [Numeric] r_2
    # @return [Numeric] A rate of return that is closer to the actual internal rate of return
    #   than the previous iteration
    def iterate(cashflows, dates, r_1, r_2)
      fn_1 = Xnpv.new(r_1, cashflows, dates).result
      fn_2 = Xnpv.new(r_2, cashflows, dates).result

      r_1 - (fn_1 * (r_1 - r_2)) / (fn_1 - fn_2)
    end

    # Solve the Xirr
    # @param [Array<Numeric>] cashflows
    # @param [Numeric] r_1
    # @param [Numeric] r_2
    # @return [DecNum] The internal rate of return
    def solve(cashflows, dates, r_1, r_2)
      NUM_ITERATIONS.times do
        break if r_1.infinite? || converged?(r_1, r_2)
        r_2, r_1 = [r_1, iterate(cashflows, dates, r_1, r_2)]
      end

      r_1.infinite? ? r_2 : r_1
    end

    # Default first guess for use in the secant method
    # @see https://en.wikipedia.org/wiki/Internal_rate_of_return#Numerical_solution_for_single_outflow_and_multiple_inflows
    def initial_r_1
      @initial_r_1 ||= cap_a_over_abs_cap_c_0 ** (2 / Flt::DecNum(@cashflows.length.to_s)) - 1
    end

    # Default second guess for use in the secant method
    # @see https://en.wikipedia.org/wiki/Internal_rate_of_return#Numerical_solution_for_single_outflow_and_multiple_inflows
    def initial_r_2
      (1 + initial_r_1) ** p - 1
    end

    def cap_a_over_abs_cap_c_0
      cap_a / abs_c_0
    end
    
    def cap_a
      @cap_a ||= @cashflows[1..-1].sum
    end

    def abs_c_0
      @cashflows[0].abs
    end

    def p
      Flt::DecNum(Math.log(cap_a_over_abs_cap_c_0).to_s) / Flt::DecNum(Math.log(cap_a / npv_1_in(initial_r_1)).to_s)
    end

    def npv_1_in(rate)
      @flows ||= Xnpv.new(rate, [0] + @cashflows[1..-1].flatten, @dates).result
    end

    def converged?(r_1, r_2)
      (r_1 - r_2).abs < @eps
    end
  end
end