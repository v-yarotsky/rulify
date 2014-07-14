$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rulify'

require 'minitest/autorun'

class RulifyAcceptanceTest < Minitest::Test
  # def test(name, &blk)
  #   if blk
  #     define_method("test_#{name}", &blk)
  #   else
  #     define_method("test_#{name}") { skip }
  #   end
  # end

  # def xtest(name)
  #   define_method("test_#{name}") { skip }
  # end
end

