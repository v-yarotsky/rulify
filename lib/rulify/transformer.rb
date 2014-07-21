require 'parslet'

module Rulify
  class Transformer < Parslet::Transform
    rule(:identifier => simple(:x)) { String(x) }
    rule(:numeric => simple(:x)) { Integer(x) }
    rule(:list => sequence(:ary)) { Array(ary) }
    rule(:range => {
      :from => simple(:from),
      :to => simple(:to)
    }) { Range.new(from, to) }

    rule(:input_ref => {
      :dictionary_name => simple(:dict),
      :entry_name => simple(:entry)
    }) { inputs[dict][entry] }

    rule(:output_ref => {
      :entry_name => simple(:entry)
    }) { outputs[entry] }

    rule(:operation => simple(:op)) { operations[op] }
  end
end

