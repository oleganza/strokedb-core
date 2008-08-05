module StrokeDB
  module Core
    module StrokeObjects
      # Instance of this class is a module containing connection to a database. 
      # Include this module into the classes of interest, which represent different kinds of objects.
      # DatabaseMixin.new(:path => 'pth-to-database', :nsurl => "http://myhost.com/")
      # Initialization options:
      #   :path       Path to the database node setup folder.
      #   :address    Database node address ("strokedb://host:port/", "http://host:port") [under construction]
      #   :nsurl      Optional NSURL string used to generate UUIDs for classes (SHA-1(nsurl + class.name))
      #               Default is "http://localhost/"
      class DatabaseMixin < Module
        attr_reader :repo, :path
        attr_reader :extend_with_class_methods
        
        include InstanceMethods
        
        DEFAULT_OPTIONS = {
          :extend_with_class_methods => true,
          :nsurl                     => "http://localhost/"
        }
        
        def initialize(options)
          OptionsHash!(options, DEFAULT_OPTIONS)
          
          @extend_with_class_methods = options["extend_with_class_methods"]
          @path = options.require("path")
          FileUtils.mkdir_p(@path)
          repo_path = File.join(@path, "repository")

          @repo = ClassFactory.new(Repositories::DefaultUuidHelpers, 
                                   Repositories::HashHelper, 
                                   Repositories::MarshalHelper, 
                                   Repositories::TokyoCabinetRepository,
                                   Repositories::MetadataHashLayer).new_class.new
          
          @repo.open(:path => repo_path)
          
          at_exit do
            @repo.close
          end
        end
        
        def included(base)
          base.extend(ClassMethods) if @extend_with_class_methods
        end
        
        # This method catches slot access calls. 
        # Slots are created on the fly.
        def method_missing(meth, *args, &blk)
          # TODO
        end

      end
    end
  end
end
