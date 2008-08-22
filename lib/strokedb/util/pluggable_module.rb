module StrokeDB
  # 
  # module DatabaseAPI
  #   extend PluggableModule  # <- magic starts here!
  #   include Validations
  #   include Associations
  # end
  #
  # module Person
  #   include DatabaseAPI
  #   has_many :articles, :as => :author  # this method is defined by PluggableModule 
  # end
  #
  # module Article
  #   include DatabaseAPI
  #   belongs_to :author
  #   validates_kind_of :author, Person
  # end
  #
  module PluggableModule
    # When plugin is included, replay all the extends. 
    def included(mod)
      @extends.each do |ext|
        mod.extend(ext)
      end
      super
    end
      
    def extend(mod)
      @extends ||= []
      @extends << mod
      super
    end
  end
end
