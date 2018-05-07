module FinancialCalculator
  class Irr
    # @return [Numeric] The internal rate of return 
    # @example
    #   FinancialCalculator::Irr.new([-123400, 36200, 54800, 48100]).result.round(4) #=> DecNum('0.0596')
    attr_reader :result

    # The number of iterations to perform while attempting to minimize the root.
    NUM_ITERATIONS = 1_000

    # Creates a new Irr instance
    # @param [Array<Numeric>] values An array of cash flows.
    # @param [Numeric] r_1 An optional first guess to use for the secant method.
    # @param [Numeric] r_2 An optional second guess to use for the secant method.
    # @return [FinancialClaculator::Irr] An Irr instance 
    # @see http://en.wikipedia.org/wiki/Internal_rate_of_return
    # @api public
    def initialize(values, r_1 = nil, r_2 = nil)
      unless (values[0].positive? ^ values[1].positive?) & values[0].nonzero?
        raise ArgumentError.new('The values do not converge') 
      end
      @eps = 1e-7
      @values = values.map { |val| DecNum(val.to_s) }

      r_1 ||= initial_r_1
      r_2 ||= initial_r_2

      @result = solve(@values, r_1, r_2)
    end

    private

    # Perform a single iteration
    # @param [Array<Numeric>] values
    # @param [DecNum] r_1
    # @param [DecNum] r_2
    # @return [DecNum] A rate of return that is closer to the actual internal rate of return
    #   than the previous iteration
    def iterate(values, r_1, r_2)
      fn_1 = Npv.new(r_1, values).result
      fn_2 = Npv.new(r_2, values).result

      r_1 - (fn_1 * (r_1 - r_2)) / (fn_1 - fn_2)
    end

    # Solve the IRR
    # @param [Array<Numeric>] values
    # @param [DecNum] r_1
    # @param [DecNum] r_2
    # @return [DecNum] The internal rate of return
    def solve(values, r_1, r_2)
      NUM_ITERATIONS.times do
        break if r_1.infinite? || converged?(r_1, r_2)
        r_2, r_1 = [r_1, iterate(values, r_1, r_2)]
      end

      r_1.infinite? ? r_2 : r_1
    end

    # Default first guess for use in the secant method
    # @see https://en.wikipedia.org/wiki/Internal_rate_of_return#Numerical_solution_for_single_outflow_and_multiple_inflows
    def initial_r_1
      @initial_r_1 ||= cap_a_over_abs_cap_c_0 ** (2 / DecNum(@values.length.to_s)) - 1
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
      @cap_a ||= @values[1..-1].sum
    end

    def abs_c_0
      @values[0].abs
    end

    def p
      DecNum(Math.log(cap_a_over_abs_cap_c_0).to_s) / DecNum(Math.log(cap_a / npv_1_in(initial_r_1)).to_s)
    end

    def npv_1_in(rate)
      @flows ||= Npv.new(rate, [0] + @values[1..-1].flatten).result
    end

    def converged?(r_1, r_2)
      (r_1 - r_2).abs < @eps
    end
  end
end