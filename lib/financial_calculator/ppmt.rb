module FinancialCalculator
  # Calculates the principal portion of a loan or annuity for a particular period
  class Ppmt
    include ::Validator

    # @return [Numeric] The rate used for calculating the payment amount
    # @api public
    attr_reader :rate

    # @return [Numeric] The amortization period
    # @api public
    attr_reader :period

    # @return [Numeric] The number of payments to be made
    # @api public
    attr_reader :num_periods

    # @return [Numeric] The current value of the annuity
    # @api public
    attr_reader :present_value

    # @return [Numeric] The ending value of the annuity. Defaults to 0
    # @api public
    attr_reader :future_value

    # @return [Boolean] Whether the payment is made at the beginning of the 
    #   period (true) or end of the period (false)
    # @api public
    attr_reader :pay_at_beginning

    # @return [DecNum] Result of the PMT calculation
    # @api public
    attr_reader :result

    # Create a new object for calculating the periodic payment of an ordinary annuity
    # @param [Numeric] rate The discount (interest) rate
    # @param [Numeric] period The amortization period
    # @param [Numeric] num_periods The number of payments to be made
    # @param [Numeric] present_value The current value of the annuity 
    # @param [Numeric] future_value The ending value of the annuity
    # @param [Boolean] pay_at_beginning. Whether the payment is made at the beginning
    #   of the period (true) or end of the period (false) 
    # @return [FinancialCalculator::Npv] An instance of a PMT calculation
    def initialize(rate, period, num_periods, present_value, future_value = 0, pay_at_beginning = false)
      validate_numerics(rate: rate, period: period, num_periods: num_periods, present_value: present_value, future_value: future_value)

      @rate             = Flt::DecNum(rate.to_s)
      @period           = Flt::DecNum(period)
      @num_periods      = Flt::DecNum(num_periods.to_s)
      @present_value    = Flt::DecNum(present_value.to_s)
      @future_value     = Flt::DecNum(future_value.to_s)
      @pay_at_beginning = pay_at_beginning
      @result           = solve(@rate, @period, @num_periods, @present_value, @future_value, @pay_at_beginning)
    end

    # @return [Boolean] Whether the payments are made at the beginning of each period
    # @api public
    def pays_at_beginning?
      @pay_at_beginning
    end

    def inspect
      "PPMT(#{result})"
    end

    private

    def solve(rate, period, nper, pv, fv, pay_at_beginning)
      payment = FinancialCalculator::Pmt.new(rate, nper, pv, fv, pay_at_beginning).result
      ipmt = FinancialCalculator::Ipmt.new(rate, period, nper, pv, fv, pay_at_beginning).result
      @result = payment - ipmt
    end
  end
end