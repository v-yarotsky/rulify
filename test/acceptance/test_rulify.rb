require 'acceptance_test_helper'

class TestRulify < RulifyAcceptanceTest
  test "simple rules" do
    result = evaluate(
      inputs("id" => "1"),
      outputs("gift_20_coins", "no_gift"),

      "if user.id is 1 then gift_20_coins"
    )

    assert_equal "gift_20_coins", result
  end

  test "default rule" do
    result = evaluate(
      inputs("id" => "100"),
      outputs("gift_20_coins", "no_gift"),

      "if user.id is 1 then gift_20_coins\n" \
      "if none then no_gift"
    )

    assert_equal "no_gift", result
  end

  test "no rules matched and no default rule" do
    exception = assert_raises(Rulify::UnexpectedCase) do
      evaluate(
        inputs("id" => "100"),
        outputs("gift_20_coins"),

        "if user.id is 1 then gift_20_coins"
      )
    end

    assert_match /No rules matched\. Consider adding default/, exception.message
  end

  group "default rule ops" do
    def passes(text)
      result = evaluate(
        inputs("id" => "100"),
        outputs("passed"),
        text
      )
      assert_equal "passed", result
    end

    def fails(text)
      assert_raises(Rulify::UnexpectedCase) do
        evaluate(
          inputs("id" => "100"),
          outputs("passed"),
          text
        )
      end
    end

    test "is" do
      passes "if user.id is 100 then passed"
      fails  "if user.id is 2 then passed"
    end

    test "=" do
      passes "if user.id = 100 then passed"
      fails  "if user.id = 2 then passed"
    end

    test "in" do
      passes "if user.id in (99, 100) then passed"
      fails  "if user.id in (99, 101) then passed"
    end

    test ">" do
      passes "if user.id > 1 then passed"
      fails  "if user.id > 100 then passed"
    end

    test ">=" do
      passes "if user.id > 1 then passed"
      passes "if user.id >= 100 then passed"
      fails  "if user.id >= 101 then passed"
    end

    test "<" do
      passes "if user.id < 101 then passed"
      fails  "if user.id < 100 then passed"
    end

    test "<=" do
      passes "if user.id <= 101 then passed"
      passes "if user.id <= 100 then passed"
      fails  "if user.id <= 99 then passed"
    end

    test "within" do
      passes "if user.id within (90..100) then passed"
      passes "if user.id within (90..110) then passed"
      fails  "if user.id within (101..110) then passed"
    end

    test "starts with" do
      passes "if user.id starts with 1 then passed"
      passes "if user.id starts with 10 then passed"
      fails  "if user.id starts with 2 then passed"
    end

    test "ends with" do
      passes "if user.id ends with 0 then passed"
      passes "if user.id ends with 00 then passed"
      fails  "if user.id ends with 1 then passed"
    end

    test "contains" do
      passes "if user.id contains 00 then passed"
      passes "if user.id contains 100 then passed"
      fails  "if user.id contains 2 then passed"
    end
  end

  def inputs(values)
    { "user" => values }
  end

  def outputs(*values)
    values.map { |v| [v, v] }.to_h
  end

  def evaluate(inputs, outputs, rules_text)
    rules = Rulify::Rules.new(rules_text.strip, inputs, outputs)
    rules.evaluate
  end
end
