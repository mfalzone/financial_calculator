module Validator
  protected 
  def validate_numerics(numerics)
    numerics.each do |key, value|
      unless value.is_a? Numeric
        raise ArgumentError.new("#{key} must be a type of Numeric. Got #{value.class} instead.")
      end
    end
  end
end