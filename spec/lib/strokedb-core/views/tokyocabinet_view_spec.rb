require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe Views::TokyoCabinetView do
  
  def find(view, opts = {})
    opts[:start_key] = opts[:end_key] = opts[:key] if opts[:key]
    view.find(*([:start_key, :end_key, :limit, :offset, :reverse, :with_keys].map{|p|opts[p]}))
  end
  
  before(:all) do
    @v = ClassFactory.new(Views::TokyoCabinetView).new_class.new
    @v.open(:path => TEMP_STORAGES + "/tc.view")
  end

  after(:all) do
    @v.close
  end
  
  it "should insert and find something with various params" do
    @v.update_pairs(Hash[*%w[ p1:c1 11  p2:c1 21  p1:c2 12 p1:c0 10 ]])
    find(@v).should == %w[ 10 11 12 21 ]
    find(@v, :reverse => true).should == %w[ 10 11 12 21 ].reverse
    find(@v, :key => "p1").should == %w[ 10 11 12 ]
    find(@v, :start_key => "p1").should == %w[ 10 11 12 21 ]
    find(@v, :start_key => "p2").should == %w[ 21 ]
    find(@v, :start_key => "p1", :reverse => true).should == %w[ 12 11 10 ]
    find(@v, :start_key => "p2", :reverse => true).should == %w[ 21 12 11 10]
    find(@v, :key => "p2", :reverse => true).should == %w[ 21 ]
    
    find(@v, :end_key => "p2").should == %w[ 10 11 12 21 ]
    find(@v, :end_key => "p1").should == %w[ 10 11 12 ]
    find(@v, :end_key => "m").should == %w[  ]
    find(@v, :end_key => "m", :reverse => true ).should == %w[ 21 12 11 10]
    find(@v, :end_key => "x").should == %w[ 10 11 12 21 ]
    find(@v, :end_key => "x", :reverse => true ).should == %w[ ]
    
    find(@v, :end_key => "p  ").should == %w[ ]
    find(@v, :end_key => "pxx").should == %w[ 10 11 12 21 ]
  end
  
end