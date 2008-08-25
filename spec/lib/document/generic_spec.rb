require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "document with metas", :shared => true do
  
  it { @doc[:uuid].should_not be_nil }
  it { @doc[:metas].should be_kind_of(Array) }
  it { @doc[:metas].should_not be_empty }
  it "for each meta should respond positively to kind_of?, is_a?" do
    @doc[:metas].each do |meta|
      @doc.is_a?(meta).should == true
      @doc.kind_of?(meta).should == true
      meta.should === meta
      meta.should === @doc
    end
  end
  it "should be a positive target against meta.===" do
    @doc[:metas].each do |meta|
      meta.should === @doc # doc
    end
  end
  
end

describe "meta", :shared => true do
  
  it { @doc.should equal(@doc) }
  it { @doc.should eql(@doc) }
  it { @doc.should == @doc }
  it { @doc.should === @doc }
  it { @doc[:uuid].should_not be_nil }
  it "should have both name and nsurl or none at all" do
    if @doc[:name] || @doc[:nsurl]
      @doc[:name].should_not be_nil
      @doc[:nsurl].should_not be_nil
    end
  end
  it "should have UUID calculated from name+nsurl if name's given" do
    if @doc[:name]
      @doc[:uuid].should == Util.sha1_uuid(@doc[:nsurl] + "/" + @doc[:name])
    end
  end

  it_should_behave_like "document with metas"
  
end
