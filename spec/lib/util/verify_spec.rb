require File.dirname(__FILE__) + '/spec_helper'

describe "verify", :shared => true do
  it do
    lambda{  @context.verify{ true }  }.should_not raise_error
  end
  it do
    lambda{  @context.verify{ false }  }.should raise_error(Util::VerifyFailed)
  end
  it "should return the block results" do
    obj = Object.new
    @context.verify{ obj }.should == obj
  end
end

describe "Util.verify" do
  before(:each) do
    @context = Util
  end
  it_should_behave_like "verify"
end

describe "Util#verify" do
  before(:each) do
    @context = Class.new{include Util}.new
  end
  it_should_behave_like "verify"
end
