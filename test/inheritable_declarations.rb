#!/usr/bin/env ruby

module Declarations
  
  # When set up a new child, notify all the ancestors
  # When add declaration to a parent, update all known children
  module SelfMethods
    def setup(container, *args)
      setup_inheritance(container, args)

      macros = [:validates_presence_of, :before_save, :has_many, :has_one, :validates_confirmation_of]
      container_class = (class <<container; self; end)
      macros.each do |macro|
        define_macro = MacroDefiner.new(container, macro).method(:define_macro)
        container_class.send(:define_method, macro, &define_macro) 
      end
    end
  
    def setup_inheritance(container, args)
      extender = ClassMethods
      container.extend(extender)
      container.declarations_setup_args = args
      parents = container.ancestors.select{|m| extender === m }
      parents.each{|p| p.declare_child(container) }
    end
  end
  
  extend SelfMethods
  
  # This class is used instead of simple proc{|*args, &blk| }
  # because Ruby 1.8.6 doesn't like &blk in a block arguments list.
  class MacroDefiner
    def initialize(container, macro)
      @container = container
      @macro = macro
    end
    def define_macro(*args, &blk)
      @container.add_declaration(@macro, args, blk)
    end
  end
  
  module ClassMethods
    attr_accessor :declarations, 
                  :declarations_children,
                  :declarations_setup_args
    
    # Updates self and children decls
    def add_declaration(macro, args, blk)
      # note: children contain self already
      @declarations_children.each do |child|
        (child.declarations ||= []) << [macro, args, blk]
      end
    end
    
    # 1. Adds local declarations to a child
    # 2. Remembers a child in a children list
    def declare_child(child)
      return if @declarations_children && @declarations_children.include?(child)
      child.declarations ||= []
      child.declarations += (declarations || [])
      (@declarations_children ||= []) << child
    end
    
    # Overriden Module#include to catch lazily added decls.
    def include(mod)
      if ClassMethods === mod
        # setup as an include module (can be overriden)
        Declarations.setup(self, mod.declarations_setup_args) unless ClassMethods === self
        super
        Declarations.setup_inheritance(self, mod.declarations_setup_args)
      else
        super
      end
    end
  end # ClassMethods
end # Declarations


# Test

module SomeSimpleModule
end

module SomeLazyModule
  Declarations.setup(self)
end

module SomeModule
  Declarations.setup(self)
  include SomeLazyModule
    
  validates_presence_of :a, :b 
  before_save :a, :b
  has_many :a, :b => :x
  
end

class BaseBaseClass
end

class BaseClass < BaseBaseClass
  Declarations.setup(self)
  
  validates_presence_of :c, :d
  before_save :c, :d
  has_one :c, :d => :y
  
end

class MyClass < BaseClass
  include SomeModule
  include SomeSimpleModule
  Declarations.setup(self)
  validates_confirmation_of :x, :z
end

module SomeLazyModule
  has_many :lazyness
end

module SomeVeryLazyModule
  Declarations.setup(self)
  has_many :much, :more, :lazyness
end

module SomeLazyModule
  include SomeVeryLazyModule
end

puts MyClass.declarations.map{|line| line.inspect}









