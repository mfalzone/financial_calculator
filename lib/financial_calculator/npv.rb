module FinancialCalculator
  # Calculates the present value of a series of equally spaced cashflows of unequal amounts
  class Npv

    # @return [Numeric] The rates used for calculating the present value
    # @api public
    attr_reader :rate

    # @return [Arrray<Numeric>] An array of cashflow amounts
    # @api public
    attr_reader :cashflows

    # @return [DecNum] Result of the XNPV calculation
    # @api public
    attr_reader :result

    # Create a new net present value calculation
    # @see https://en.wikipedia.org/wiki/Net_present_value
    # @param [Numeric] rate The discount (interest) rate
    # @param [Array<Numeric>] cashflows An array of cashflows 
    # @return [FinancialCalculator::Npv] An instance of a Net Present Value calculation
    def initialize(rate, cashflows)
      raise ArgumentError.new("Rate must be a Numeric. Got #{rate.class} instead") unless rate.is_a? Numeric

      @rate     = rate
      @cashflows = cashflows
      @result   = solve(rate, cashflows)
    end

    def inspect
      "NPV(#{result})"
    end

    private

    def solve(rate, cashflows)
      cashflows.each_with_index.reduce(0) do |total, (payment, index)|
        total += payment / (1 + rate) ** (index + 1)
      end 
    end
  end

  NetPresentValue = Npv
end