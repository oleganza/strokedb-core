require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe Declarations do
  
  before(:all) do
    # Sample DSL
    abstract_callbacks = Module.new do
      def abstract_callback(name, *methods, &blk)
        list = local_declarations(name, [])
        list = methods.reverse + list # insert in reversed order for ancestors' order complience.
        list.unshift(blk) if blk
        local_declarations_set(name, list)
      end
      def abstract_callback_list(name)
        inherited_declarations(name) do |inherited_data|
          inherited_data.inject([]) do |stack, callbacks|
            stack + callbacks
          end
        end
      end
    end
    
    @after_save = Module.new do
      include abstract_callbacks
      include StrokeDB::Declarations
      
      def after_save(*methods, &blk)
        abstract_callback(:after_save, *methods, &blk)
      end
      def after_save_callbacks
        abstract_callback_list(:after_save)
      end
    end
    
    @before_save = Module.new do
      include abstract_callbacks
      include StrokeDB::Declarations
      
      def before_save(*methods, &blk)
        abstract_callback(:before_save, *methods, &blk)
      end
      def before_save_callbacks
        abstract_callback_list(:before_save)
      end
    end
  end
  
  #
  # Generic specifications
  #
    
  describe "generic relations", :shared => true do
    
    it "should store simple declarations in a single container" do
      before_save_mod = @before_save
      c = @single      
      c.after_save_callbacks.should  == [:b, :a]

      c.module_eval do
        extend before_save_mod
        before_save_callbacks.should == [ ]
        after_save :c
        before_save :x, :y
      end

      c.after_save_callbacks.should  == [:c, :b, :a]
      c.before_save_callbacks.should == [:y, :x]
    end
    
    
    it "should inherit callbacks and data" do
      base, sub = @base, @sub
      
      base.after_save_callbacks.should  == [:b, :a]
      base.before_save_callbacks.should == [ ]
      sub.after_save_callbacks.should   == [:b, :a]
      sub.before_save_callbacks.should  == [ ]
    
      # Updating parent
      base.module_eval do 
        after_save :c
        before_save :x
      end
    
      base.after_save_callbacks.should  == [:c, :b, :a]
      base.before_save_callbacks.should == [:x]
      sub.after_save_callbacks.should   == [:c, :b, :a]
      sub.before_save_callbacks.should  == [:x]
    
      # Update child
      sub.module_eval do 
        after_save :s
        before_save :q
      end
      base.after_save_callbacks.should  == [:c, :b, :a]
      base.before_save_callbacks.should == [:x]
      sub.after_save_callbacks.should   == [:s, :c, :b, :a]
      sub.before_save_callbacks.should  == [:q, :x]
    
      sub.module_eval do 
        after_save :w
      end
      base.after_save_callbacks.should  == [:c, :b, :a]
      sub.after_save_callbacks.should   == [:w, :s, :c, :b, :a]
    end
    
    
    it "should lazily inherit DSL when included into ancestor" do
      # before
      @dsl_sub.after_save_callbacks.should == [ :x ]
      @dsl_sub.after_save_callbacks.should == [ :x ]
      @plain_base.should_not respond_to(:after_save_callbacks)
      @plain_sub.should_not respond_to(:after_save_callbacks)
      
      # setup
      @new_after_save_mod = Module.new
      @new_after_save_mod.extend(@after_save)
      @new_after_save_mod.after_save :y
      
      @plain_base.send(:include, @new_after_save_mod)
      
      # after
      @plain_base.after_save_callbacks.should == [ :y ]
      @plain_sub.after_save_callbacks.should  == [ :y ]
      @dsl_sub.after_save_callbacks.should    == [ :x, :y ]
    end
    
  end
  
  #
  # Specific setups
  #
  
  describe "Classes" do
    before(:each) do
      after_save_mod = @after_save
      before_save_mod = @before_save
      
      @plain_base = Class.new
      @plain_sub = Class.new(@plain_base)
      @dsl_sub = Class.new(@plain_base) do
        extend after_save_mod
        after_save :x
      end
      
      @single = Class.new do
        extend after_save_mod
        after_save_callbacks.should  == [ ]
        after_save :a, :b
      end
      
      @base = Class.new {
        extend after_save_mod
        extend before_save_mod
        after_save :a, :b
      }
      @sub = Class.new(@base)
    end
    
    it_should_behave_like "generic relations"
  end
  
  describe "Modules" do
    before(:each) do
      after_save_mod = @after_save
      before_save_mod = @before_save

      @plain_base = Module.new
      @plain_sub = Module.new
      # Here the problem arises: plain base is not aware 
      # of what modules included it. So it can't properly extend 
      # these modules with decls API when needed.
      @plain_sub.send(:include, @plain_base)
      
      @dsl_sub = Module.new
      @dsl_sub.send(:include, @plain_base) 
      @dsl_sub.module_eval do
        extend after_save_mod
        after_save :x
      end
      
      @single = Module.new do
        extend after_save_mod
        after_save_callbacks.should  == [ ]
        after_save :a, :b
      end
      
      @base = Module.new {
        extend after_save_mod
        extend before_save_mod
        after_save :a, :b
      }
      @sub = Module.new
      @sub.send :include, @base
    end
    
    it_should_behave_like "generic relations"
  end
    
end


describe Declarations, "lazy DSL definition" do
  before(:each) do
    # define methods without Declarations inclusion.
    @after_save = Module.new do
      def after_save(*methods, &blk)
        list = local_declarations(:after_save, [])
        list = methods.reverse + list # insert in reversed order for ancestors' order complience.
        list.unshift(blk) if blk
        local_declarations_set(name, list)
      end
      def after_save_callbacks
        inherited_declarations(:after_save) do |inherited_data|
          inherited_data.inject([]) do |stack, callbacks|
            stack + callbacks
          end
        end
      end
    end
    
    after_save_mod = @after_save
    @base_mod = Module.new do
      extend after_save_mod
    end
    
    @sub_mod = Module.new
    @sub_mod.send :include, @base_mod
    
    # And now, finally extend our DSL with StrokeDB::Declarations
    @after_save.send(:include, StrokeDB::Declarations)
  end
  
  it "should work" do
    @base_mod.after_save_callbacks.should == []
    @sub_mod.after_save_callbacks.should == []
    @base_mod.after_save :base
    @base_mod.after_save_callbacks.should == [:base]
    @sub_mod.after_save_callbacks.should == [:base]
    @sub_mod.after_save :sub
    @base_mod.after_save_callbacks.should == [:base]
    @sub_mod.after_save_callbacks.should == [:sub, :base]
  end
end

