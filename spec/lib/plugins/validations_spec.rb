require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe "Validations" do
  
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
    end
    @person = Class.new do
      include Validations
      include contacts_validations
      validate_presence_of :name
    end
  end
  
  it "should be inheritable when defined in a module" do
    map = Proc.new do |v|
      [v.class, v.slotname.to_sym]
    end
    @contacts_validations.validations.map(&map).should == [
      [Validations::Presence, :phone],
      [Validations::Presence, :email]
    ]
    @person.validations.map(&map).should == [
      [Validations::Presence, :name],
      [Validations::Presence, :phone],
      [Validations::Presence, :email]
    ]
    @more_validations.validations.map(&map).should == [
      [Validations::Presence, :more],
      [Validations::Presence, :phone],
      [Validations::Presence, :email]
    ]
    @person.send(:include, @more_validations)
    @person.validations.map(&map).should == [
      [Validations::Presence, :name],
      [Validations::Presence, :more],
      [Validations::Presence, :phone],
      [Validations::Presence, :email]
    ]
  end

  it "should be inheritable when defined in base class"  
  it "should implement basic validations"
  
end  