require 'acceptance_test_helper'

class TestRulify < RulifyAcceptanceTest
  module Rulify
    require 'parslet'
    class Parser < Parslet::Parser
      rule(:rules) { base_case.repeat(1) }

      rule(:base_case) { str("when") >> space >> expression.as(:expression) >> space >> str("then") >> space >> output_ref.as(:output) >> newline? }

      rule(:input_ref) { identifier.as(:dictionary_name) >> str(".") >> identifier.as(:entry_name) }
      rule(:expression) { is_expression | none_expression }
      rule(:output_ref) { identifier.as(:entry_name) }

      rule(:none_expression) { str("none").as(:name) }
      rule(:is_expression) { input_ref.as(:lhs_value) >> space >> str("is").as(:name) >> space >> value.as(:rhs_value) }

      rule(:value) { numeric_value }
      rule(:numeric_value) { match("[\\d]").repeat(1) }

      rule(:space) { match("[\\s]").repeat(1) }
      rule(:space?) { space.maybe }
      rule(:newline) { match("\\n").repeat(1) }
      rule(:newline?) { newline.maybe }
      rule(:identifier) { match("[a-zA-Z]") >> match("[a-zA-Z0-9_]").repeat(1) }

      root(:rules)
    end

    class Rules
      class Rule
        attr_reader :output

        def initialize(expression, output)
          @expression, @output = expression, output
        end

        def satisfied?
          case @expression[:name].to_s
          when "is"
            @expression[:lhs_value] == @expression[:rhs_value]
          when "none"
            true
          else
            raise ArgumentError, "Unknown expression: #{@expression[:name]}"
          end
        end
      end

      class UnmatchedRule
        def initialize(rules)
          @rules = rules
        end

        def output
          raise "No rules matched. Consider adding default output. Rules:\n#{@rules.map(&:inspect).join("\n")}"
        end
      end

      def initialize(rules_text, inputs, outputs)
        @parsed = Parser.new.parse(rules_text)
        @rules = @parsed.map do |rule|
          expression = rule[:expression]
          expression.merge!(lhs_value: inputs.fetch(rule[:expression][:lhs_value][:entry_name].to_s)) if expression[:lhs_value]
          output = outputs.fetch(rule[:output][:entry_name].to_s)
          Rule.new(expression, output)
        end
      rescue Parslet::ParseFailed => failure
        warn failure.cause.ascii_tree
      end

      def evaluate
        rule = @rules.detect(&:satisfied?) || UnmatchedRule.new(@rules)
        rule.output
      end
    end
  end


  def test_simple_rules
    user_inputs  = { "id" => "1" }
    gift_outputs = outputs("gift_20_coins", "no_gift")
    rules = Rulify::Rules.new <<CODE.strip, user_inputs, gift_outputs
when user.id is 1 then gift_20_coins
CODE

    result = rules.evaluate

    assert_equal "gift_20_coins", result
  end

  def test_rules_with_fallback
    user_inputs  = { "id" => "100" }
    gift_outputs = outputs("gift_20_coins", "no_gift")
    rules = Rulify::Rules.new <<CODE.strip, user_inputs, gift_outputs
when user.id is 1 then gift_20_coins
when none then no_gift
CODE

    result = rules.evaluate

    assert_equal "no_gift", result
  end

  def outputs(*values)
    values.map { |v| [v, v] }.to_h
  end
end
