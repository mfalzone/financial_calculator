module FinancialCalculator
  module Solvers
    class SecantSolver

      attr_reader :result

      def initialize(values, r_1 = nil, r_2 = nil)
        @eps = 1e-7
        @values = values.map(&:to_f)

        r_1 ||= initial_r_1
        r_2 ||= initial_r_2

        solve(@values, r_1, r_2)
      end

      private

      def iterate(values, r_1, r_2)
        fn_1 = values.npv(r_1)
        fn_2 = values.npv(r_2)

        # puts "r_1: #{r_1}, fn_1: #{fn_1}, r_2: #{r_2}, fn_2: #{fn_2}"

        r_1 - (fn_1 * (r_1 - r_2)) / (fn_1 - fn_2)
      end

      def solve(values, r_1, r_2, iterations = 100_000)
        iterations.times do
          r_2, r_1 = [r_1, iterate(values, r_1, r_2)]
          break if r_1.infinite? || converged?(r_1, r_2)
        end

        # puts "npv_r_1 = #{values.npv(r_1)}, npv_r_2 = #{values.npv(r_2)}"
        # puts "(r_1 - r_2).abs < 1e-7 == #{(r_1.to_f - r_2.to_f).abs} < #{@eps} == #{(r_1.to_f - r_2.to_f).abs < @eps} "
        # puts "r_1 infinite? #{r_1.infinite?}, converged? #{converged?(r_1, r_2)}"
        @result = r_1.infinite? ? r_2 : r_1
      end

      def initial_r_1
        @initial_r_1 ||= cap_a_over_abs_cap_c_0 ** (2 / @values.length.to_f) - 1
      end

      def initial_r_2
        (1 + initial_r_1) ** p - 1
      end

      def cap_a_over_abs_cap_c_0
        cap_a / abs_c_0.to_f
      end
      
      def cap_a
        @cap_a ||= @values[1..-1].sum
      end

      def abs_c_0
        @values[0].abs
      end

      def p
        Math.log(cap_a_over_abs_cap_c_0) / Math.log(cap_a / @values[1..-1].npv(initial_r_1))
      end

      def converged?(r_1, r_2)
        (r_1 - r_2).abs < @eps
      end

    end
  end
end