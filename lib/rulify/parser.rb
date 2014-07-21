require 'parslet'

module Rulify
  class Parser < Parslet::Parser
    rule(:rules) { base_case.repeat(1) }

    rule(:base_case) { str("if") >> space >> expression.as(:expression) >> space >> str("then") >> space >> output_ref.as(:output) >> newline? }

    rule(:input_ref) { (identifier.as(:dictionary_name) >> str(".") >> identifier.as(:entry_name)).as(:input_ref) }
    rule(:expression) { basic_expression | none_expression }
    rule(:output_ref) { (identifier.as(:entry_name)).as(:output_ref) }

    rule(:basic_expression) { input_ref.as(:lhs_value) >> space >> operation.as(:op) >> space >> value.as(:rhs_value) }
    rule(:none_expression) { noop.as(:op) }

    rule(:operation) { ((atomic_identifier >> (space >> atomic_identifier).repeat) | operator).as(:operation) }
    rule(:noop) { str("none").as(:operation) }

    rule(:value) { list | range | numeric_value }
    rule(:numeric_value) { match("[\\d]").repeat(1).as(:numeric) }
    rule(:list) { lparen >> (value >> (comma >> value).repeat).as(:list) >> rparen }
    rule(:range) { lparen >> (value.as(:from) >> str("..") >> value.as(:to)).as(:range) >> rparen }

    rule(:space) { match("[\\s]").repeat(1) }
    rule(:space?) { space.maybe }
    rule(:newline) { match("\\n").repeat(1) }
    rule(:newline?) { newline.maybe }
    rule(:comma) { str(",") >> space? }
    rule(:lparen) { str("(") }
    rule(:rparen) { str(")") }
    rule(:atomic_identifier) { match("[a-zA-Z]") >> match("[a-zA-Z0-9_]").repeat(1) }
    rule(:identifier) { atomic_identifier.as(:identifier) }
    rule(:operator) { str("<=") | str(">=") | str("=") | str("<") |  str(">") }

    root(:rules)

    def parse(*)
      super
    rescue Parslet::ParseFailed => failure
      warn failure.cause.ascii_tree
      raise
    end
  end
end

