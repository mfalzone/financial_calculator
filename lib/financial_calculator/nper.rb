module FinancialCalculator
  # Calculates the number of periods in an annuity
  class Nper
    include ::Validator

    # @return [Numeric] The rate used for calculating the number of payments
    # @api public
    attr_reader :rate

    # @return [Numeric] The amount of each payment made
    # @api public
    attr_reader :payment

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
    # @param [Numeric] payment The amount of each payment made
    # @param [Numeric] present_value The current value of the annuity 
    # @param [Numeric] future_value The ending value of the annuity
    # @param [Boolean] pay_at_beginning. Whether the payment is made at the beginning
    #   of the period (true) or end of the period (false) 
    # @return [FinancialCalculator::Nper] An instance of NPER calculation
    def initialize(rate, payment, present_value, future_value = 0, pay_at_beginning = false)
      validate_numerics(rate: rate, payment: payment, present_value: present_value, future_value: future_value)

      @rate             = Flt::DecNum(rate.to_s)
      @payment          = Flt::DecNum(payment.to_s)
      @present_value    = Flt::DecNum(present_value.to_s)
      @future_value     = Flt::DecNum(future_value || "0")
      @pay_at_beginning = pay_at_beginning || false
      @result           = solve(@rate, @payment, @present_value, @future_value, @pay_at_beginning)
    end

    # @return [Boolean] Whether the payments are made at the beginning of each period
    # @api public
    def pays_at_beginning?
      @pay_at_beginning
    end

    def inspect
      "NPER(#{result})"
    end

    private

    def solve(rate, pmt, pv, fv, pay_at_beginning)
      type = pay_at_beginning ? 1 : 0
      initial = pmt * (1 + rate * type)

      # TODO: Insert better error handling if either argument is negative.
      @result = Math.log((initial - fv * rate) / (initial + pv * rate)) / Math.log(1.0 + rate)
    end
  end
end