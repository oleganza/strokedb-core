$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")
require 'strokedb-core'
include StrokeDB

dir = File.dirname(__FILE__)

MyDatabase = StrokeObjects::Database.new(
                :path    => File.join(dir, ".mml.strokedb"),
                :plugins => [ Validations ]
                )

module MML
  
  module CommonMixins
    include StrokeDB::Associations
    include StrokeDB::Validations
  end
  
  module Account
    include CommonMixins
    
    belongs_to :owner
    has_many :account_memberships, :slot => :account
    has_many :members, :through => :account_memberships
    has_many :projects
    
    validates_kind_of :owner, Person
  end

  module AccountMembership
    include CommonMixins

    belongs_to :account
    belongs_to :person
    
    validates_kind_of :account, Account
    validates_kind_of :person, Person
  end
  
  module Person
    include CommonMixins
    has_many :owned_accounts, :slot => :owner
    
    has_many :account_memberships, :slot => :person
    has_many :accounts, :through => :account_memberships
    has_many :project_memberships, :slot => :person
    has_many :projects, :through => :project_memberships
  end

  module ProjectMembership
    include CommonMixins
    
    belongs_to :project
    belongs_to :person
    
    validates_kind_of :project, Project
    validates_kind_of :person, Person
  end

  module Project
    include CommonMixins
    
    belongs_to :account
    has_many :project_memberships, :slot => :project
    has_many :members, :through => :project_memberships
    has_many :files, :slot => :folder
    
    validates_kind_of :account, Account
  end

  module DataFile
    include CommonMixins
    
    belongs_to :folder # just getter/setter for a reference 
    
    validates_kind_of :folder, :one_of => [ Folder, Project ]
  end

  module Folder
    include CommonMixins
    
    belongs_to :folder
    has_many :files, :slot => :folder # view is updated when someone references a folder
    
    validates_kind_of :folder, :one_of => [ Folder, Project ]
  end
end

include MML
include Util


oleg = verify { Person.create(:name => "Oleg Andreev", :email => "oleganza@gmail.com") }
oleg_account = verify { Account.create(:name => "Oleg Andreev's account", :owner => oleg) }
oleg_personal_account = verify { oleg.owned_accounts.create(:name => "Oleg Andreev's personal account") }




















