#!/usr/bin/env ruby

module Declarations
  
  # When set up a new child, notify all the ancestors
  # When add declaration to a parent, update all known children
  module SelfMethods
    def setup(container, plugins)
      container.extend(ClassMethods)
      container.decls_setup(plugins)
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
                  :decls_children,
                  :decls_plugins
    
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
    
    def inherited(subclass)
      
    end
    
    def included(submodule)
      # do nothing if submodule is already declarifized (see #include)
      return if ClassMethods === submodule
      
    end
    
    # Overriden Module#include to catch lazily added decls.
    def include(mod)
      super
      self.inherit_decls(mod)
    end
    
    # When we mix in new module or class into hierarchy:
    # 1. This module must inherit all decls in the ancestors
    # 2. Update all the children with its own declarations
    #
    # What to inherit:
    # 1. Declarations.
    # 2. Configuration
    #
    def inherit_decls(mod)
      if mod == ClassMethods
        
      end
    end
    
  end # ClassMethods
  
  module InstanceMethods
    def extend(mod)
      super
      class <<self; self; end.inherit_decls(mod)
    end
  end
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









