require File.dirname(__FILE__) + '/spec_helper'

# TODO: spec arguments for Class.new and Class#new.

describe "ClassFactory.make_module" do
  
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
    mod = ClassFactory.make_module([@a, @b])
    @obj.extend(mod)
    @obj.should be_kind_of(@a)
    @obj.should be_kind_of(@b)
    @obj.m.should == "ba"
  end
  
  it "should return an argument if it is already a module (not a list)" do
    mod = ClassFactory.make_module(@a)
    mod.object_id.should == @a.object_id
  end
end

describe "ClassFactory.make_class" do
  
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
  end
  
  it "should make a module consisting of stack of modules" do
    cls = ClassFactory.make_class([@a, @b])
    obj = cls.new
    obj.should be_kind_of(@a)
    obj.should be_kind_of(@b)
    obj.m.should == "ba"
  end
  
  it "should return an argument if it is already a module (not a list)" do
    cls = ClassFactory.make_class(@a)
    obj = cls.new
    obj.should be_kind_of(@a)
    obj.m.should == "a"
  end
end

describe "ClassFactory.make_instance" do
  
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
  end
  
  it "should make a module consisting of stack of modules" do
    obj = ClassFactory.make_instance([@a, @b])
    obj.should be_kind_of(@a)
    obj.should be_kind_of(@b)
    obj.m.should == "ba"
  end
  
  it "should return an argument if it is already a module (not a list)" do
    obj = ClassFactory.make_instance(@a)
    obj.should be_kind_of(@a)
    obj.m.should == "a"
  end
end
