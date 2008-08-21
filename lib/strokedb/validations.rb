prefix = "strokedb/validations"
require "#{prefix}/class_methods"
require "#{prefix}/instance_methods"
require "#{prefix}/presence"

# TODO: more validations
#require "#{prefix}/format"
#require "#{prefix}/uniqueness"
#require "#{prefix}/numericality"
#require "#{prefix}/kind"
# ...

module StrokeDB
  module Validations
    def self.included(mod)
      mod.extend(ClassMethods)
      mod.send(:include, InstanceMethods)
    end
  end
end
