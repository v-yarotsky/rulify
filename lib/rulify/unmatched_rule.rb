module Rulify
  class UnmatchedRule
    def initialize(rules)
      @rules = rules
    end

    def output
      raise UnexpectedCase, "No rules matched. Consider adding default output. Rules:\n#{@rules.map(&:inspect).join("\n")}"
    end
  end
end

