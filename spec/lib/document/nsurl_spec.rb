require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe NSURL do
  before(:each) do
    base = @base = Module.new do
      extend NSURL
    end
    @sub = Module.new do
      include base
    end
  end
  
  it "should be nil by default" do
    @base.nsurl.should == nil
  end
  
  it "should be set with #nsurl=" do
    @base.nsurl = "http://abc.com"
    @base.nsurl.should == "http://abc.com"
  end
  
  it "should be set with #nsurl(url)" do
    @base.nsurl "http://xyz.com"
    @base.nsurl.should == "http://xyz.com"
  end
  
  it "should be inheritable and overwriteable" do
    # sub inherits base's nsurl if doesn't have own value
    @base.nsurl = "http://xyz.com"
    @sub.nsurl.should == "http://xyz.com"
    @base.nsurl = "http://qwe.com"
    @sub.nsurl.should == "http://qwe.com"
    # sub defines its own value
    @sub.nsurl = "http://sub.com"
    @base.nsurl.should == "http://qwe.com"
    @sub.nsurl.should == "http://sub.com"
    # changed base, but submodule keeps its nsurl
    @base.nsurl = "http://base.com"
    @sub.nsurl.should == "http://sub.com"
  end

end


describe NSURL::Ours do
  before(:each) do
    base = @base = Module.new do
      include NSURL::Ours
    end
    @sub = Module.new do
      include base
    end
  end
  
  it "should be strokedb nsurl" do
    @base.nsurl.should == STROKEDB_NSURL
    @sub.nsurl.should == STROKEDB_NSURL
  end
  
end


describe NSURL::Theirs do
  before(:each) do
    base = @base = Module.new do
      include NSURL::Ours
    end
    @sub = Module.new do
      include base
      include NSURL::Theirs
    end
  end
  
  it "should be default nsurl in children" do
    @base.nsurl.should == STROKEDB_NSURL
    @sub.nsurl.should == DEFAULT_NSURL
  end
  
end
