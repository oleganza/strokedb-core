prefix = "strokedb/validations"
require "#{prefix}/class_methods"
require "#{prefix}/instance_methods"
require "#{prefix}/errors"
require "#{prefix}/base_slot_validation"
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
      mod.extend(ClassMethods)
      mod.send(:include, InstanceMethods)
    end
  end
end
