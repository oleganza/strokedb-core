module StrokeDB
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
      attr_reader :repo, :path, :nsurl
      # configuration for the experts
      attr_reader :repository_api, :plugins
      
      DEFAULT_OPTIONS = {
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
        
        @plugins = options.require("plugins").map do |plugin| 
          plugin.configure(self, options) if plugin.respond_to?(:configure)
          plugin
        end
        
        @repository_api    = options.require("repository_api")
        @path              = options.require("path") # FIXME: support networking
        FileUtils.mkdir_p(@path)
        
        @repo_class = ClassFactory.new(*@repository_api).new_class
        @repo = new_repo(@repo_class)
            
        DEBUG do
          puts "#{self.class.inspect} configuration:"
          [:@repository_api, :@plugins].each do |ivar|
            puts "  #{(ivar.to_s+':').ljust(20)} #{instance_variable_get(ivar).inspect}"
          end
        end
      end
      
      def new_repo(repo_class)
        repo = repo_class.new
        repo_path = File.join(@path, "repository")
        repo.open(:path => repo_path)
        at_exit { repo.close }
        repo
      end
      private :new_repo
      
      def included(base)
        # First, extend and include core methods
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        
        # Then, include plugins (plugin can extend class with its own 
        # class methods in the Module#included hook)
        @plugins.each{|pl|   base.send(:include, pl) }
        
        # Call the callback when all modules are included.
        base.strokedb_configured(self)
      end
      
    end
  end
end
