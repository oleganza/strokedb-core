module StrokeDB
  module Core
    module Util
      class ClassFactory
        attr_accessor :composite_module, :modules
        
        def initialize(*modules)
          @modules = modules
          @composite_module = if modules.size == 1
            modules.first
          else
            Module.new do
              modules.each do |m|
                include m
              end
            end
          end
        end
        
        def new_class(*class_args)
          m = @composite_module
          Class.new(*class_args) do
            include m
          end
        end
        
      end
    end # Repositories
  end # Core
end # StrokeDB
