module Rulify
  class Rules
    def initialize(rules_text, inputs, outputs)
      parsed = Parser.new.parse(rules_text)
      transformed = Transformer.new.apply(parsed, inputs: inputs, outputs: outputs, operations: method(:operations))
      @rules = transformed.map { |rule| Rule.new(rule[:expression], rule[:output]) }
    end

    def evaluate
      rule = @rules.detect(&:satisfied?) || UnmatchedRule.new(@rules)
      rule.output
    end

    def operations(op)
      case op.to_s
      when "is", "="
        proc { |left, right| left.to_s == right.to_s }
      when "in", "within"
        proc { |left, right| right.include?(left.to_i) }
      when ">"
        proc { |left, right| left.to_i > right.to_i }
      when ">="
        proc { |left, right| left.to_i >= right.to_i }
      when "<"
        proc { |left, right| left.to_i < right.to_i }
      when "<="
        proc { |left, right| left.to_i <= right.to_i }
      when "starts with"
        proc { |left, right| left.to_s.start_with?(right.to_s) }
      when "ends with"
        proc { |left, right| left.to_s.end_with?(right.to_s) }
      when "contains"
        proc { |left, right| left.to_s.include?(right.to_s) }
      when "none"
        proc { true }
      end
    end
  end
end

