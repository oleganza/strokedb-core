module StrokeDB
  module Core
    module Util
      module ClassFactory
        def self.make_instance(modules, class_args = [], instance_args = [])
          make_class(modules, class_args).new(*instance_args)
        end
        
        def self.make_class(modules, class_args = [])
          mod = make_module(modules)
          Class.new(*class_args) do
            include mod
          end
        end
        
        def self.make_module(modules)
          return modules if modules.is_a?(Module)
          Module.new do
            modules.each do |m|
              include m
            end
          end
        end
      end
    end # Repositories
  end # Core
end # StrokeDB
