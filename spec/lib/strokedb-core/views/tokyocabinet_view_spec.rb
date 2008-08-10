require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe Views::TokyoCabinetView do
  
  def find_with_options(view, opts)
    view.find(*([:start_key, :end_key, :limit, :offset, :reverse, :with_keys].map{|p|opts[p]}))
  end
  
  before(:all) do
    @v = ClassFactory.new(Views::TokyoCabinetView).new_class.new
    @v.open(:path => TEMP_STORAGES + "/tc.view")
  end

  after(:all) do
    @v.close
  end
  
  it "should insert and find something" do
    @v.update_pairs(Hash[*%w[ p1:c1 11  p2:c1 21  p1:c2 12 p1:c0 10 ]])
    find_with_options(@v, :start_key => "p1", :end_key => "p1").should == %w[ 10 11 12 ]
    find_with_options(@v, :start_key => "p1").should == %w[ 10 11 12 21 ]
    find_with_options(@v, :start_key => "p2").should == %w[ 21 ]
    find_with_options(@v, :start_key => "p1", :reverse => true).should == %w[ 12 11 10 ]
    find_with_options(@v, :start_key => "p2", :reverse => true).should == %w[ 21 12 11 10]
    find_with_options(@v, :start_key => "p2", :end_key => "p2", :reverse => true).should == %w[ 21 ]
    
  end
  
end