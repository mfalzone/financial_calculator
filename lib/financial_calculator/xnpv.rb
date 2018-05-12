module FinancialCalculator
  # Calculate the net present value of a series of unequally spaced, (potentially) unequal cashflows
  class Xnpv
    # @return [Numeric] The rates used for calculating the present value
    # @api public
    attr_reader :rate

    # @return [Array<Numeric>] An array of cashflow amounts
    # @api public
    attr_reader :cashflows

    # @return [Array<Date>] An array of dates on which the cashflows occur
    # @api public
    attr_reader :dates

    # @return [DecNum] Result of the XNPV calculation
    # @api public
    attr_reader :result

    # Allows for creating an XNPV calculation with an array of any objects that respond to #amount and #date
    # @param [Numeric] rate The discount (interest) rate
    # @param [Array<Transaction>] transaction An array of Transaction objects.
    # @return [FinancialCalculator::Xnpv]
    # @api public
    def self.with_transactions(rate, transactions)
      raise ArgumentError.new("Argument \"rate\" must be a Numeric. Got #{rate.class} instead") unless rate.is_a? Numeric
      unless transactions.all? { |t| t.is_a? Transaction }
        raise ArgumentError.new("Argument \"transactions\" must be an array of Transaction")
      end

      cashflows  = transactions.map(&:amount)
      dates      = transactions.map(&:date)

      self.new(rate, cashflows, dates)
    end

    # Create a new XNPV calculation
    # @param [Numeric] rate The discount (interest) rate
    # @param [Array<Numeric>] cashflows An array of cashflows
    # @param [Array<Date>] dates An array of dates representing when each cashflow occurs
    # @return [FinancialCalculator::Xnpv]
    # @raise [ArgumentError] When cashflows and dates are not the same length
    # @raise [ArgumentError] When dates is not an array of Date
    # @api public
    def initialize(rate, cashflows, dates)
      validate_cashflows_dates_size(cashflows, dates)
      validate_dates(dates)

      @rate       = Flt::DecNum(rate.to_s)
      @cashflows  = cashflows.map { |cashflow| Flt::DecNum(cashflow.to_s) }.freeze
      @dates      = dates.freeze
      @result     = solve(rate, cashflows, dates)
    end
    
    # @api public
    def inspect
      "XNPV(#{result})"
    end

    private

    # Solve the NPV calcluation.
    # @note This methods uses a 365 day year regardless of whether or not the 
    #   year is actually a leap year. This is done in order to maintain 
    #   consistency with common implementations such as Excel and Google Sheets. 
    #   In the future it would be nice to have a flag that allows for using 
    #   the actual number of days in the year
    def solve(rate, cashflows, dates)
      start         = dates[0]
      transactions  = cashflows.zip(dates) 
      amount_index  = 0
      date_index    = 1
      
      transactions.reduce(0) do |total, transaction|
        total += transaction[amount_index] / ((1 + @rate) ** (Flt::DecNum(transaction[date_index] - start) / 365)) 
      end
    end
    
    def validate_dates(dates)
      unless dates.all? { |date| date.is_a? Date }
        raise ArgumentError.new("Argument dates must be an array of Date")
      end
    end

    def validate_cashflows_dates_size(cashflows, dates)
      unless dates.length == cashflows.length
        raise ArgumentError.new("Arguments cashflows and dates must be the same length")
      end
    end
  end
end