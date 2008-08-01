require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "OptionsHash!(hash)" do
  
  before(:each) do
    @h = {"a" => "string", :b => "sym"}
    @oh = OptionsHash!(@h)
  end
  
  it { @oh.object_id.should == @h.object_id }
  it { @h.should be_kind_of(OptionsHash) }
  it { @h.should respond_to(:require) }
  
  it "should accept already optionized Hash" do
    lambda { OptionsHash!(@h) }.should_not raise_error
    @h.should be_kind_of(OptionsHash)
    @h.should respond_to(:require)
  end
end

describe "OptionsHash#require" do
  
  before(:each) do
    @h = {"a" => "string", :b => "sym"}
    @oh = OptionsHash!(@h)
  end
  
  it { @h.require("a").should == "string" }
  it { @h.require(:a).should == "string" }
  it { @h.require("b").should == "sym" }
  it { @h.require(:b).should == "sym" }
  
  it "should accept already optionized Hash" do
    lambda { @h.require("x") }.should raise_error(OptionsHash::RequiredOptionMissing)
    lambda { @h.require(:x) }.should raise_error(OptionsHash::RequiredOptionMissing)
  end
end

describe "OptionsHash#[]" do
  
  before(:each) do
    @h = {"a" => "string", :b => "sym"}
    @h.default = "default"
    @oh = OptionsHash!(@h)
  end
  
  it { @h["a"].should == "string" }
  it { @h[:a].should  == "string" }
  it { @h["b"].should == "sym" }
  it { @h[:b].should  == "sym" }
  it { @h[:x].should  == "default" }
  it { @h["x"].should == "default" }
  
end

describe "OptionsHash#[]=" do
  
  before(:each) do
    @h = {"a" => "string", :b => "sym"}
    OptionsHash!(@h)
    @h[:a]  = "string2"
    @h["b"] = "sym2"
    @h[:x]  = "x"
    @h["y"] = "y"
  end
  
  it { @h["a"].should == "string2" }
  it { @h[:a].should  == "string2" }
  it { @h["b"].should == "sym2" }
  it { @h[:b].should  == "sym2" }
  it { @h[:x].should  == "x" }
  it { @h["x"].should == "x" }
  it { @h[:y].should  == "y" }
  it { @h["y"].should == "y" }
end
