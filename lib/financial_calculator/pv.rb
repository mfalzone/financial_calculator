module FinancialCalculator
  # Calculate the present value of a series of equal of payments
  class Pv
    include ::Validator

    # @return [Numeric] The discount rate used in the calculation
    attr_reader :rate

    # @return [Numeric] The number of periodic payments
    attr_reader :num_periods

    # @return [Numeric] The amount of the periodic payment
    attr_reader :payment

    # @return [Numeric] The value remaining after the final payment has been made
    attr_reader :future_value

    # @return [Numeric] The result of the present value calculation
    attr_reader :result

    # Create a new present value calculation
    #
    # @see https://en.wikipedia.org/wiki/Present_value
    # @example
    #   FinancialCalculator::Pv.new(0.02, 10, -100) #=> PresentValue(898.2585006242236)
    # @param [Numeric] rate The discount (interest) rate to use
    # @param [Numeric] num_periods The number of periodic payments
    # @param [Numeric] payment The amount of the periodic payment
    # @param [Numeric] future_value The value remaining after the final payment has been made
    # @param [Boolean] pay_at_beginning Whether the payments are made at the beginning or end of each period
    # @return [FinancialCalculator::Pv] A Pv object
    # @raise [ArgumentError] Raises an ArgumentError if num_periods is less than 0 or a required numeric
    #   field is given a non-numeric value
    def initialize(rate, num_periods, payment, future_value = 0, pay_at_beginning = false)
      validate_numerics(rate: rate, num_periods: num_periods, payment: payment, future_value: future_value)

      if num_periods < 0
        raise ArgumentError.new('Cannot calculate present value with negative periods. Use future value instead.')
      end

      @rate             = Flt::DecNum(rate.to_s)
      @num_periods      = Flt::DecNum(num_periods.to_s)
      @payment          = Flt::DecNum(payment.to_s)
      @future_value     = Flt::DecNum(future_value.to_s)
      @pay_at_beginning = pay_at_beginning
      @result           = solve(@rate, @num_periods, @payment, @future_value, pay_at_beginning)
    end

    def inspect
      "PV(#{result})"
    end

    # @return [Boolean] Whether the payments are made at the beginning of each period
    def pays_at_beginning?
      @pay_at_beginning
    end

    private

    def solve(rate, num_periods, payment, future_value, pay_at_beginning)
      start_period  = pay_at_beginning ? 0 : 1
      end_period    = pay_at_beginning ? num_periods - 1 : num_periods

      present_value = (start_period..end_period.abs).reduce(Flt::DecNum('0')) do |total, t|
        total += discount(payment, rate, t)
      end

      -(present_value + discount(future_value, rate, num_periods))
    end

    def discount(amount, rate, periods)
      return 0 if amount.zero?
      amount / (1 + rate) ** periods 
    end
  end

  PresentValue = Pv
end