prefix = "strokedb/associations"
require "#{prefix}/class_methods"
require "#{prefix}/instance_methods"
require "#{prefix}/belongs_to"
require "#{prefix}/has_many"

module StrokeDB
  module Associations
    def self.included(mod)
      mod.extend(ClassMethods)
      mod.send(:include, InstanceMethods)
    end
  end
end
