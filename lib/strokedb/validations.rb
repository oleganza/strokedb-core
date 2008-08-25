prefix = "strokedb/validations"
require "#{prefix}/errors"
require "#{prefix}/base_slot_validation"
require "#{prefix}/base"
require "#{prefix}/presence"
require "#{prefix}/kind"
# TODO: more validations
#require "#{prefix}/format"
#require "#{prefix}/uniqueness"
#require "#{prefix}/numericality"
# ...

module StrokeDB
  module Validations
    def self.included(mod)
      mod.extend(Presence)
      mod.extend(Kind)
      #mod.extend(Format)
      #mod.extend(Uniqueness)
      #mod.extend(Numericality)
    end
  end
end
