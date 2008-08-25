module StrokeDB
  module Associations
    module BelongsTo
      include Base
      #  
      # belongs_to :slotname
      #
      def belongs_to(slotname, options = {})
        register_association(Association.new({:slotname => slotname}.merge(options)))
      end
    
      class Association
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
        end
      end # Association
    end # BelongsTo
  end # Validations
end # StrokeDB
