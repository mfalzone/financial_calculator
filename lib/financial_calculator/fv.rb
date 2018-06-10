module FinancialCalculator
  # Calculate the future value of a series of equal of payments
  class Fv
    include ::Validator

    # @return [Numeric] The discount rate used in the calculation
    attr_reader :rate

    # @return [Numeric] The number of periodic payments
    attr_reader :num_periods

    # @return [Numeric] The amount of the periodic payment
    attr_reader :payment

    # @return [Numeric] The current value
    attr_reader :present_value

    # @return [Numeric] The result of the future value calculation
    attr_reader :result

    # Create a new future value calculation
    #
    # @see https://en.wikipedia.org/wiki/Future_value
    # @example
    #   FinancialCalculator::Fv.new(0.02, 10, -100) #=> FV(1094.972100)
    # @param [Numeric] rate The discount (interest) rate to use
    # @param [Numeric] num_periods The number of periodic payments
    # @param [Numeric] payment The amount of the periodic payment
    # @param [Numeric] present_value The current value
    # @param [Boolean] pay_at_beginning Whether the payments are made at the beginning or end of each period
    # @return [FinancialCalculator::Fv] A Fv object
    # @raise [ArgumentError] Raises an ArgumentError if num_periods is less than 0 or a required numeric
    #   field is given a non-numeric value
    def initialize(rate, num_periods, payment, present_value = 0, pay_at_beginning = false)
      validate_numerics(rate: rate, num_periods: num_periods, payment: payment, present_value: present_value)

      if num_periods < 0
        raise ArgumentError.new('Cannot calculate future value with negative periods. Use present value instead.')
      end

      @rate             = Flt::DecNum(rate.to_s)
      @num_periods      = Flt::DecNum(num_periods.to_s)
      @payment          = Flt::DecNum(payment.to_s)
      @present_value    = Flt::DecNum(present_value.to_s)
      @pay_at_beginning = pay_at_beginning
      @result           = solve(@rate, @num_periods, @payment, @present_value, pay_at_beginning)
    end

    def inspect
      "FV(#{result})"
    end

    # @return [Boolean] Whether the payments are made at the beginning of each period
    def pays_at_beginning?
      @pay_at_beginning
    end

    private

    def solve(rate, num_periods, payment, future_value, pay_at_beginning)
      annuity_due = pay_at_beginning ? 1 : 0
      compound = (1 + rate) ** num_periods

      -((present_value * compound) + (payment * (1 + rate * annuity_due) * (compound - 1) / rate))
    end
  end

  FutureValue = Fv
end