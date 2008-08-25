require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "document with metas", :shared => true do
  
  it { @doc[:uuid].should_not be_nil }
  it { @doc[:metas].should be_kind_of(Array) }
  it { @doc[:metas].should_not be_empty }
  it "for each meta should respond kind_of?(meta)" do
    @doc[:metas].each do |meta|
      @doc.should be_kind_of(meta)
    end
  end
  
end

describe "meta", :shared => true do
  
  it { @doc[:name].should_not be_nil }
  it { @doc[:nsurl].should_not be_nil }
  it { @doc[:uuid].should_not be_nil }

  it_should_behave_like "document with metas"
  
end
