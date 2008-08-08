module StrokeDB
  module Core
    module StrokeObjects
      # Instance of this class is a module containing connection to a database. 
      # Include this module into the classes of interest, which represent different kinds of objects.
      # Database.new(:path => 'pth-to-database', :nsurl => "http://myhost.com/")
      # Initialization options:
      #   :path       Path to the database node setup folder.
      #   :address    Database node address ("strokedb://host:port/", "http://host:port") [under construction]
      #   :nsurl      Optional NSURL string used to generate UUIDs for classes (SHA-1(nsurl + class.name))
      #               Default is "http://localhost/"
      class Database < Module
        # configuration for the rest of us
        attr_reader :repo, :path
        # configuration for the experts
        attr_reader :extend_by_modules, :include_modules, :repository_api
        
        DEFAULT_OPTIONS = {
          :extend_by_modules => [ClassMethods],
          :include_modules   => [InstanceMethods],
          :repository_api    => [
                                  Repositories::AbstractRepository,
                                  Repositories::AbstractHelpers,
                                  Repositories::DefaultUuidHelpers, 
                                  Repositories::HashHelper, 
                                  Repositories::MarshalHelper, 
                                  Repositories::TokyoCabinetRepository,
                                  Repositories::MetadataHashLayer
                                ],
          :plugins           => [],
          :nsurl             => "http://localhost/"
        }
        
        def initialize(options)
          OptionsHash!(options, DEFAULT_OPTIONS)
          
          @plugins = options.require("plugins").map {|plugin_class| plugin_class.new(self, options) }
          
          @extend_by_modules = options.require("extend_by_modules") || []
          @include_modules   = options.require("include_modules")   || []
          @repository_api    = options.require("repository_api")
          @path              = options.require("path") # FIXME: support networking
          FileUtils.mkdir_p(@path)
          repo_path = File.join(@path, "repository")
          
          @repo = ClassFactory.new(*@repository_api).new_class.new
          @repo.open(:path => repo_path)
          
          DEBUG do
            puts "#{self.class.inspect} configuration:"
            [:@extend_by_modules, :@include_modules, :@repository_api].each do |ivar|
              puts "  #{(ivar.to_s+':').ljust(20)} #{instance_variable_get(ivar).inspect}"
            end
          end
          at_exit { @repo.close }
        end
        
        def included(base)
          @extend_by_modules.each{|cm| base.extend(cm)         }
          @include_modules.each{|im|   base.send(:include, im) }
          base.strokedb_configured(self)
        end
        
      end
    end
  end
end
