require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "TokyoCabinetRepository with default setup" do
  before(:all) do
    @r = ClassFactory.new(Repositories::DefaultUuidHelpers, 
                          Repositories::HashHelper, 
                          Repositories::MarshalHelper, 
                          Repositories::TokyoCabinetRepository,
                          Repositories::MetadataHashLayer).new_class.new
    @r.open(:path => TEMP_STORAGES + "/tc.repo")
  end

  after(:all) do
    @r.close
  end 
  
  it "should create/read/updated/delete" do 
    d0 = @r.new_document
    uuid, version1 = @r.post(d0.dup)
    uuid.should =~ UUID_RE
    version1.should =~ UUID_RE
    
    d1 = @r.get(uuid)
    d1["uuid"].should == uuid
    d1["version"].should == version1
    d1["previous_version"].should be_nil
    
    d1 = @r.get_version(version1)
    d1["uuid"].should == uuid
    d1["version"].should == version1
    
    version2 = @r.put(uuid, d1.dup)
    version2.should =~ UUID_RE
    
    d2 = @r.get_version(version2)
    
    d2["uuid"].should == uuid
    d2["version"].should == version2
    d2["previous_version"].should == version1

    @r.uuids_count.should == 1
    @r.versions_count.should == 2
    
    a = []
    @r.each do |uuid, doc|
      a << [uuid, doc]
    end
    
    a.should == [[uuid, d2]]

    a = []
    @r.each_version do |version, doc|
      a << [version, doc]
    end
    
    sorter = proc{|x,y| x[0]<=>y[0] }
    a.sort(&sorter).should == [[version1, d1], [version2, d2]].sort(&sorter)
    
  end
  
end
