require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe InheritableAttributes do
  it "should define attributes on a class" do
    obj = Class.new do
      extend InheritableAttributes
      define_inheritable_attribute(:color)
    end
    obj.should respond_to(:color)
    obj.should respond_to(:color=)
    obj.should respond_to(:color_inherited)
    
    obj.color = :red
    obj.color.should == :red
    obj.color_inherited.should == [:red]
  end
  
  it "should define attributes on a module" do
    obj = Module.new do
      extend InheritableAttributes
      define_inheritable_attribute(:color)
    end
    obj.should respond_to(:color)
    obj.should respond_to(:color=)
    obj.should respond_to(:color_inherited)
    
    obj.color = :red
    obj.color.should == :red
    obj.color_inherited.should == [:red]
  end
  
  it "should inherit attributes from a base class" do
    base = Class.new do
      extend InheritableAttributes
      define_inheritable_attribute(:color)
      self.color = :red
    end
    base.color.should == :red
    sub = Class.new(base) do
      color.should == nil
      color_inherited.should == [:red]
      self.color = :blue
      self.color_inherited.should == [:blue, :red]
    end
    base.color.should == :red
    sub.color.should == :blue
    base.color_inherited.should == [:red]
    sub.color_inherited.should == [:blue, :red]
    
    # should update sub's data by base data
    base.color = :green
    base.color_inherited.should == [:green]
    sub.color_inherited.should == [:blue, :green]
    sub.color.should == :blue
  end
  
  it "should inherit attributes with a lazily updated module" do
    mod = Module.new do
      extend InheritableAttributes
      define_inheritable_attribute(:color)
      self.color = :red
    end
    mod2 = Module.new do
      extend InheritableAttributes
      define_inheritable_attribute(:color)
    end
    mod.send(:include, mod2)
    base = Class.new do
      include mod
      self.color_inherited.should == [:red]
      self.color = :blue
      self.color_inherited.should == [:blue, :red]
    end
    mod2.color = :second
    base.color_inherited.should == [:blue, :red, :second]
    base.color.should == :blue
  end
end
