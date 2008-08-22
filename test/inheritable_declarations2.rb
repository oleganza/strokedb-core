#!/usr/bin/env ruby

module InheritableAttributes
  def include(mod)
    invalidate_children_78f4156b_f3cb_55e8_9083_680ed199f277
    super
  end
  def extend(mod)
    invalidate_children_78f4156b_f3cb_55e8_9083_680ed199f277
    super
  end
  def included(mod)
    invalidate_children_78f4156b_f3cb_55e8_9083_680ed199f277(mod)
    super
  end
  def extended(mod)
    invalidate_children_78f4156b_f3cb_55e8_9083_680ed199f277(mod)
    super
  end
  IAUUID = "78f4156b_f3cb_55e8_9083_680ed199f277"
  def invalidate_children_78f4156b_f3cb_55e8_9083_680ed199f277(mod = self)
    mod.instance_variables.grep(/children_#{IAUUID}$/) do |ivar|
      (mod.instance_variable_get(ivar) || []).each do |child|
        child.instance_variable_set("#{ivar}_cache", nil)
      end
    end
  end
  
  def define_inheritable_attribute(name)
    
    ivar_cache         = "@#{name}_children_#{IAUUID}_cache"
    ivar_children      = "@#{name}_children_#{IAUUID}"
    ivar_children_get  = "instance_variable_get(:#{ivar_children})"
    ivar_children_set_ = "instance_variable_set(:#{ivar_children}"
    
    meta_class = (class <<self; self; end)
    meta_class.module_eval(code = <<-EVAL, __FILE__, __LINE__)
      def #{name}
        @#{name}
      end
      def #{name}=(v)
        @#{name} = v
        # Invalidate all inherited ivars instead of the needed one. 
        # The code is already messy, so i don't even try to be THAT smartass.
        invalidate_children_78f4156b_f3cb_55e8_9083_680ed199f277
        v
      end
      def all_#{name}
        #{ivar_cache} ||= ancestors.inject([]) do |memo, ancestor|
          c = ancestor.#{ivar_children_get}
          ancestor.#{ivar_children_set_}, ((c || []) << self).uniq)
          memo.push(ancestor.#{name}) if ancestor.respond_to?(:#{name})
          memo
        end
      end
    EVAL
  end
end


# Test

module Generator
  def method_missing(meth, *args)
    define_inheritable_attribute(:declarations)
    self.declarations ||= []
    self.declarations << [meth, args]
  end
end

InheritableAttributes.send(:include, Generator)


module SomeSimpleModule
end

module SomeLazyModule
  extend InheritableAttributes
end

module SomeModule
  extend InheritableAttributes
  include SomeLazyModule
    
  validates_presence_of :a, :b 
  before_save :a, :b
  has_many :a, :b => :x
  
end

class BaseBaseClass
end

class BaseClass < BaseBaseClass
  extend InheritableAttributes
  
  validates_presence_of :c, :d
  before_save :c, :d
  has_one :c, :d => :y
  
end

class MyClass < BaseClass
  extend InheritableAttributes
  include SomeModule
  include SomeSimpleModule
  validates_confirmation_of :x, :z
end

module SomeLazyModule
  has_many :lazyness
end

module SomeVeryLazyModule
  extend InheritableAttributes
  has_many :much, :more, :lazyness
  def xxxx
    :xxxx
  end
end

module SomeLazyModule
  include SomeVeryLazyModule
end

puts MyClass.all_declarations.map{|line| line.inspect}

class BaseBaseClass
  include SomeVeryLazyModule
end

p MyClass.ancestors

puts MyClass.all_declarations.map{|line| line.inspect}









