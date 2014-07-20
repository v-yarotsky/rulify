module Rulify
  class Rules
    def initialize(rules_text, inputs, outputs)
      @parsed = Parser.new.parse(rules_text)
      @rules = @parsed.map do |rule|
        expression = rule[:expression]
        expression.merge!(lhs_value: inputs.fetch(rule[:expression][:lhs_value][:entry_name].to_s)) if expression[:lhs_value]
        output = outputs.fetch(rule[:output][:entry_name].to_s)
        Rule.new(expression, output)
      end
    end

    def evaluate
      rule = @rules.detect(&:satisfied?) || UnmatchedRule.new(@rules)
      rule.output
    end
  end
end

