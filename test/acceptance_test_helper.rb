$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rulify'

require 'minitest/autorun'

class RulifyAcceptanceTest < Minitest::Test
  def self.test(name, &blk)
    blk ||= proc { skip }
    define_method("test_#{name}", &blk)
  end

  def self.xtest(name)
    test(name)
  end
end

