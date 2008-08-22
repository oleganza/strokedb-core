require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "ClassFactory.new" do
  
  before(:each) do
    @a = Module.new do
      def m
        "a"
      end
    end
    @b = Module.new do
      def m
        "b" + super
      end
    end
    @obj = Object.new
  end
  
  it "should make a module consisting of stack of modules" do
    cf = ClassFactory.new(@a, @b)
    mod = cf.composite_module
    @obj.extend(mod)
    @obj.should be_kind_of(@a)
    @obj.should be_kind_of(@b)
    @obj.m.should == "ba"
  end
  
  it "should return an argument if it is already a module (not a list)" do
    cf = ClassFactory.new(@a)
    mod = cf.composite_module
    mod.object_id.should == @a.object_id
  end
end

describe "ClassFactory#new_class" do
  
  before(:each) do
    @a = Module.new do
      def m
        "a" + super
      end
    end
    @b = Module.new do
      def m
        "b" + super
      end
    end
    @sc = Class.new do
      def m
        "s"
      end
    end
  end
  
  it "should make a class consisting of stack of modules" do
    cls = ClassFactory.new(@a, @b).new_class(@sc)
    obj = cls.new
    obj.should be_kind_of(@a)
    obj.should be_kind_of(@b)
    obj.m.should == "bas"
  end
  
  it "should return an argument if it is already a module (not a list) and convert this argument into a class" do
    cls = ClassFactory.new(@a).new_class(@sc)
    obj = cls.new
    obj.should be_kind_of(@a)
    obj.m.should == "as"
  end
end


