module StrokeDB
  module Validations
    module ClassMethods
      #  
      # belongs_to :slotname
      #
      def belongs_to(slotname, options = {})
        register_association(BelongsTo.new({:slotname => slotname}.merge(options)))
      end
    end # ClassMethods
    
    class BelongsTo
      attr_accessor :slotname, :boolean
      
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
      end
    
    end # BelongsTo
  end # Validations
end # StrokeDB
