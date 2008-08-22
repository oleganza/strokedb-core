module StrokeDB
  module Associations
    module ClassMethods
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
        register_association(HasMany.new({:slotname => slotname}.merge(options)))
      end
    end # ClassMethods
    
    class HasMany
      attr_accessor :slotname
      
      def initialize(options)
        @options = OptionsHash(options)
        @slotname = @options.require(:slotname)
      end
      
      def setup(mod)
        slotname = @slotname
        mod.send(:define_method, slotname) do
          self[slotname]
        end
        mod.send(:define_method, slotname.to_s + "=") do |value|
          self[slotname] = value
        end
        
        # self.on_get_slot(slotname, )
        # on slot access -> create proxy
      end
      
      class CollectionProxy
        def initialize(document)
          
        end
      end
    
    end # BelongsTo
  end # Validations
end # StrokeDB
