require 'parslet'

module Rulify
  class Parser < Parslet::Parser
    class Transformer < Parslet::Transform
      rule(:numeric => simple(:x)) { Integer(x) }
      rule(:list => sequence(:ary)) { ary.to_a }
      rule(:range => {
        :from => simple(:from),
        :to => simple(:to)
      }) { Range.new(from, to) }
    end

    rule(:rules) { base_case.repeat(1) }

    rule(:base_case) { str("if") >> space >> expression.as(:expression) >> space >> str("then") >> space >> output_ref.as(:output) >> newline? }

    rule(:input_ref) { identifier.as(:dictionary_name) >> str(".") >> identifier.as(:entry_name) }
    rule(:expression) { is_expression | equals_expression | in_expression | gt_expression | gte_expression | lt_expression | lte_expression | within_expression | starts_with_expression | ends_with_expression | contains_expression | none_expression }
    # rule(:expression) { basic_expression | none_expression }
    rule(:output_ref) { identifier.as(:entry_name) }

    rule(:none_expression) { str("none").as(:name) }
    # rule(:basic_expression) { input_ref.as(:lhs_value) >> space >> op.as(:op) >> space >> value.as(:rhs_value)
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
    rule(:numeric_value) { match("[\\d]").repeat(1).as(:numeric) }
    rule(:list) { (value >> (comma >> value).repeat).as(:list) }
    rule(:range) { (value.as(:from) >> str("..") >> value.as(:to)).as(:range) }

    rule(:space) { match("[\\s]").repeat(1) }
    rule(:space?) { space.maybe }
    rule(:newline) { match("\\n").repeat(1) }
    rule(:newline?) { newline.maybe }
    rule(:comma) { str(",") >> space? }
    rule(:identifier) { match("[a-zA-Z]") >> match("[a-zA-Z0-9_]").repeat(1) }
    # rule(:op) { match("[<>=a-zA-Z]").repeat(1) }

    root(:rules)

    def parse(*)
      t = Transformer.new
      t.apply(super)
    rescue Parslet::ParseFailed => failure
      warn failure.cause.ascii_tree
      raise
    end
  end
end

