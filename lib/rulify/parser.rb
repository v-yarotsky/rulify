require 'parslet'

module Rulify
  class Parser < Parslet::Parser
    rule(:rules) { base_case.repeat(1) }

    rule(:base_case) { str("when") >> space >> expression.as(:expression) >> space >> str("then") >> space >> output_ref.as(:output) >> newline? }

    rule(:input_ref) { identifier.as(:dictionary_name) >> str(".") >> identifier.as(:entry_name) }
    rule(:expression) { is_expression | equals_expression | in_expression | gt_expression | gte_expression | lt_expression | lte_expression | within_expression | starts_with_expression | ends_with_expression | contains_expression | none_expression }
    rule(:output_ref) { identifier.as(:entry_name) }

    rule(:none_expression) { str("none").as(:name) }
    rule(:is_expression) { input_ref.as(:lhs_value) >> space >> str("is").as(:name) >> space >> value.as(:rhs_value) }
    rule(:equals_expression) { input_ref.as(:lhs_value) >> space >> str("=").as(:name) >> space >> value.as(:rhs_value) }
    rule(:in_expression) { input_ref.as(:lhs_value) >> space >> str("in").as(:name) >> space >> list.as(:rhs_value) }
    rule(:gt_expression) { input_ref.as(:lhs_value) >> space >> str(">").as(:name) >> space >> numeric_value.as(:rhs_value) }
    rule(:gte_expression) { input_ref.as(:lhs_value) >> space >> str(">=").as(:name) >> space >> numeric_value.as(:rhs_value) }
    rule(:lt_expression) { input_ref.as(:lhs_value) >> space >> str("<").as(:name) >> space >> numeric_value.as(:rhs_value) }
    rule(:lte_expression) { input_ref.as(:lhs_value) >> space >> str("<=").as(:name) >> space >> numeric_value.as(:rhs_value) }
    rule(:within_expression) { input_ref.as(:lhs_value) >> space >> str("within").as(:name) >> space >> range.as(:rhs_value) }
    rule(:starts_with_expression) { input_ref.as(:lhs_value) >> space >> str("starts with").as(:name) >> space >> value.as(:rhs_value) }
    rule(:ends_with_expression) { input_ref.as(:lhs_value) >> space >> str("ends with").as(:name) >> space >> value.as(:rhs_value) }
    rule(:contains_expression) { input_ref.as(:lhs_value) >> space >> str("contains").as(:name) >> space >> value.as(:rhs_value) }

    rule(:value) { numeric_value }
    rule(:numeric_value) { match("[\\d]").repeat(1) }
    rule(:list) { value >> (comma >> value).repeat }
    rule(:range) { value >> str("..") >> value }

    rule(:space) { match("[\\s]").repeat(1) }
    rule(:space?) { space.maybe }
    rule(:newline) { match("\\n").repeat(1) }
    rule(:newline?) { newline.maybe }
    rule(:comma) { str(",") >> space? }
    rule(:identifier) { match("[a-zA-Z]") >> match("[a-zA-Z0-9_]").repeat(1) }

    root(:rules)

    def parse(*)
      r = super
      # p r
      r
    rescue Parslet::ParseFailed => failure
      warn failure.cause.ascii_tree
      raise
    end
  end
end

