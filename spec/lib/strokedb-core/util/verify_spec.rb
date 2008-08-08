require File.dirname(__FILE__) + '/spec_helper'

describe "Util.verify" do
  it do
    lambda{  Util.verify{ true }  }.should_not raise_error
  end
  it do
    lambda{  Util.verify{ false }  }.should raise_error(Util::VerifyFailed)
  end
end

describe "Util#verify" do
  before(:each) do
    @obj = Class.new{include Util}.new
  end
  it do
    lambda{  @obj.verify{ true }  }.should_not raise_error
  end
  it do
    lambda{  @obj.verify{ false }  }.should raise_error(Util::VerifyFailed)
  end
end
