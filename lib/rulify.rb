require "rulify/version"

module Rulify
  autoload :Parser,        "rulify/parser"
  autoload :Transformer,   "rulify/transformer"
  autoload :Rule,          "rulify/rule"
  autoload :UnmatchedRule, "rulify/unmatched_rule"
  autoload :Rules,         "rulify/rules"
end

require "rulify/exceptions"

