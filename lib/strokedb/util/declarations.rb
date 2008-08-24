module StrokeDB
  # We want to have module methods like has_many, validates_presence_of, after_save etc.
  # Scenarios:
  #   Given a module A with such declarations, 
  #     we include A into B,
  #     B has declaration methods and inherits the data from C.
  #   Given a class C with such declarations,
  #     we inherit D from C,
  #     D has declaration methods and inherits the data from C.
  #   Given a module A mixed in B, C
  #     we add declarations
  #     B and C get these declarations and inherit data from A.
  #   Given a class C with subclasses D1, D2
  #     we add declarations
  #     D1, D2 get these declarations and inherit data from C.
  #   Given a module A mixed in B, C
  #     we modify declarations
  #     B and C inherit data from A.
  #   Given a class C with subclasses D1, D2
  #     we modify declarations
  #     D1, D2 inherit data from C.
  #
  # Issue: when we have an hierarchy of plain modules and extend some of them with a DSL,
  # all children must be extended with this DSL, right?
  # Design choices:
  # 1. keep lists of backreferences to children, this gonna waste the memory.
  # 2. handle Module#method_missing in such way, that it searches ancestors for the desired method
  #    and extends itself with 
  # 3. don't try to be THAT smart and simply tell user to "extend MyDSL" the module in case of such issue.
  #
  # We choose to be smartass (option 2)
  #
  module Declarations
    def self.included(dsl_module)
      super
      # 1. Install hooks on #included and #inherited to
      #    provide declarations 
      # 2. Install other hooks for proper cache invalidation.
      #    Cache contains a list of inherited data.
      dsl_module.extend(ExtendHooks)
      dsl_module.send(:include, API)
    end
    
    module ExtendHooks
      # When DSL extends some module, this module extends 
      # every module it is included in with this DSL.
      def extended(mod)
        dsl = self
        # We create a new module to implement proper chaining of all #included calls.
        mod_extender = Module.new
        mod_extender.send(:define_method, :included) do |submod|
          super
          submod.extend(dsl)
        end
        mod.extend(mod_extender)
        mod.instance_eval do
          @decl_dsls ||= []
          @decl_dsls << dsl
        end
        nil
      end
    end
    
    module ModuleMethods
      # Search ancestors for the missing method
      def method_missing(meth, *args, &blk)
        # 0. If this is a DSL and Declarations were included lazily,
        #    module may not have these methods. Extend it with them
        if Declarations::API.instance_methods.include?(meth.to_s) and !is_a?(Declarations::API)
          extend(Declarations::API)
          return send(meth, *args, &blk)
        end
        # 1. Find nearest module with all
        mod_with_dsl = absolutely_all_ancestors.detect {|a| a.respond_to?(meth) }
        super unless mod_with_dsl
        # 2. extended self with all the DSLs found in this module
        all_were_extended = true
        mod_with_dsl.instance_eval{ @decl_dsls || [] }.each do |dsl|
          all_were_extended &&= self.is_a?(dsl)
          extend(dsl)
        end
        # 3. try again if no circular dependency detected
        unless all_were_extended
          return send(meth, *args, &blk) 
        end
        super
      end
    end
    
    module API
      
      def include(mod)
        invalidate_decl_cache!
        mod.extend(API)
        mod.register_cache(self) # self must be invalidated when mod's ancestors are modified
        super
      end
      
      # Util.sha1_uuid("StrokeDB::Declarations::API::NOTHING").upcase.gsub(/-/,'_')
      #    #==>"CA1AF719_3EC3_56BB_A98A_C67AD40A5266"
      CA1AF719_3EC3_56BB_A98A_C67AD40A5266 = Object.new.freeze
    
      def local_declarations(name, default = CA1AF719_3EC3_56BB_A98A_C67AD40A5266)
        decls = (@local_declarations ||= Hash.new(CA1AF719_3EC3_56BB_A98A_C67AD40A5266))
        decls[name] = default if decls[name].equal?(CA1AF719_3EC3_56BB_A98A_C67AD40A5266)
        decls[name]
      end
    
      def local_declarations_set(name, value)
        decls = (@local_declarations ||= {})
        decls[name] = value
        invalidate_decl_cache!
        value
      end
    
      def inherited_declarations(name)
        decls = @inherited_declarations
        decls and data = decls[name] and return data
        @inherited_declarations ||= {}
        inherited_data = absolutely_all_ancestors.inject([]) do |memo, ancestor|
          ancestor.extend(API)
          ancestor.register_cache(self)
          local_decls = ancestor.local_declarations(name)
          memo << local_decls unless local_decls.equal?(CA1AF719_3EC3_56BB_A98A_C67AD40A5266)
          memo
        end
        @inherited_declarations[name] = yield(inherited_data)
      end
      
      def register_cache(mod)
        @decl_cached_objects ||= []
        @decl_cached_objects |= [mod]
      end
      
      # It is rude to invaidate all possible DSLs when only one 
      # DSL inheritance chain is modified, but ve-ery effective.
      def invalidate_decl_cache!
        return unless @decl_cached_objects
        @decl_cached_objects.each do |mod|
          mod.instance_variable_set(:@inherited_declarations, nil)
        end
      end

    end # API
  end # Declarations
end # StrokeDB

class Module  
  include StrokeDB::Declarations::ModuleMethods
end
