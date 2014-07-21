module Rulify
  class Rule
    attr_reader :output

    def initialize(expression, output)
      @expression, @output = expression, output
    end

    def satisfied?
      @expression[:op].call(@expression[:lhs_value], @expression[:rhs_value])
    end
  end
end

