module Rulify
  class Rule
    attr_reader :output

    def initialize(expression, output)
      @expression, @output = expression, output
    end

    def satisfied?
      case @expression[:name].to_s
      when "is", "="
        @expression[:lhs_value].to_s == @expression[:rhs_value].to_s
      when "none"
        true
      when "in", "within"
        @expression[:rhs_value].include?(@expression[:lhs_value].to_i)
      when ">"
        @expression[:lhs_value].to_i > @expression[:rhs_value].to_i
      when ">="
        @expression[:lhs_value].to_i >= @expression[:rhs_value].to_i
      when "<"
        @expression[:lhs_value].to_i < @expression[:rhs_value].to_i
      when "<="
        @expression[:lhs_value].to_i <= @expression[:rhs_value].to_i
      when "starts with"
        @expression[:lhs_value].to_s.start_with?(@expression[:rhs_value].to_s)
      when "ends with"
        @expression[:lhs_value].to_s.end_with?(@expression[:rhs_value].to_s)
      when "contains"
        @expression[:lhs_value].to_s.include?(@expression[:rhs_value].to_s)
      else
        raise ArgumentError, "Unknown expression: #{@expression[:name]}"
      end
    end
  end
end

