require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "Validations[introspection]" do
  
  before :each do
    @contacts_validations = contacts_validations = Module.new do
      include Validations
      validate_presence_of :phone
      validate_presence_of :email
    end
    @more_validations = Module.new do
      include Validations
      include contacts_validations
      validate_presence_of :more
      validate_kind_of :something
    end
    @person = Class.new do
      include Validations
      include contacts_validations
      validate_presence_of :name
    end
    @girlfriend = Class.new(@person) do
      validate_presence_of :boyfriend # :-)
    end
    @map = Proc.new do |v|
      [v.class, v.slotname.to_sym]
    end
  end
  
  it "should be inheritable when defined in a module" do
    map = @map
    
    presence = Validations::Presence::Validation
    kind     = Validations::Kind::Validation
    
    @contacts_validations.validations.map(&map).should == [
      [presence, :phone],
      [presence, :email]
    ]
    @person.validations.map(&map).should == [
      [presence, :name],
      [presence, :phone],
      [presence, :email]
    ]
    @more_validations.validations.map(&map).should == [
      [presence, :more],
      [kind,     :something],
      [presence, :phone],
      [presence, :email]
    ]
    @person.send(:include, @more_validations)
    @person.validations.map(&map).should == [
      [presence, :name],
      [presence, :more],
      [kind,     :something],
      [presence, :phone],
      [presence, :email]
    ]
  end

  it "should be inheritable when defined in a class"  do
    map = @map
    
    presence = Validations::Presence::Validation
    kind     = Validations::Kind::Validation
    
    @girlfriend.validations.map(&map).should == [
      [presence, :boyfriend],
      [presence, :name],
      [presence, :phone],
      [presence, :email]
    ]
    @person.send(:include, @more_validations)
    @girlfriend.validations.map(&map).should == [
      [presence, :boyfriend],
      [presence, :name],
      [presence, :more],
      [kind,     :something],
      [presence, :phone],
      [presence, :email]
    ]
  end
  
end  