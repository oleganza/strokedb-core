module StrokeDB
  module Associations
    module HasMany
      include Base
      #  
      # class WebSite
      #   has_many :pages
      #   has_many :reviews, :as => :reviewable_object
      #   has_many :visits
      #   has_many :visitors, :through => :visits
      #
      def has_many(slotname, options = {}, &blk)
        if blk
          options[:extensions] ||= []
          options[:extensions] << Module.new(&blk)
        end
        register_association(Association.new({:slotname => slotname}.merge(options)))
      end
    
      class Association
        attr_accessor :slotname, :options
      
        def initialize(options)
          @options = OptionsHash(options)
          @slotname = @options.require(:slotname)
        end
      
        def setup(mod)
          slotname = @slotname
          mod.extend StrokeObjects::SlotHooks
          mod.send(:define_method, slotname) do
            self[slotname]
          end
          mod.send(:define_method, slotname.to_s + "=") do |value|
            self[slotname] = value
          end
          mod.slot_hook(slotname, AssociationSlotHook)
        end
        
        module AssociationSlotHook
          def get(doc, slotname)
            ivar = "@#{slotname}"
            proxy = doc.instance_variable_get(ivar)
            proxy and return proxy
            assoc = doc.class.association(slotname)
            proxy = CollectionProxy.new(assoc)
            doc.instance_variable_set(ivar, proxy)
          end
          def set(doc, slotname, value)
            
          end
        end
        
        class CollectionProxy
          def initialize(document)
          
          end
        end
        
      end # Association
    end # BelongsTo
  end # Validations
end # StrokeDB
