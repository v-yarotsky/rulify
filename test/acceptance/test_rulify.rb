require 'acceptance_test_helper'

class TestRulify < RulifyAcceptanceTest
  test "simple rules" do
    result = evaluate(
      inputs("id" => "1"),
      outputs("gift_20_coins", "no_gift"),

      "when user.id is 1 then gift_20_coins"
    )

    assert_equal "gift_20_coins", result
  end

  test "default rule" do
    result = evaluate(
      inputs("id" => "100"),
      outputs("gift_20_coins", "no_gift"),

      "when user.id is 1 then gift_20_coins\n" \
      "when none then no_gift"
    )

    assert_equal "no_gift", result
  end

  test "no rules matched and no default rule" do
    exception = assert_raises(Rulify::UnexpectedCase) do
      evaluate(
        inputs("id" => "100"),
        outputs("gift_20_coins"),

        "when user.id is 1 then gift_20_coins"
      )
    end

    assert_match /No rules matched\. Consider adding default/, exception.message
  end

  def inputs(values)
    values
  end

  def outputs(*values)
    values.map { |v| [v, v] }.to_h
  end

  def evaluate(inputs, outputs, rules_text)
    rules = Rulify::Rules.new(rules_text.strip, inputs, outputs)
    rules.evaluate
  end
end
