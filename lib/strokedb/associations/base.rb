module StrokeDB
  module Associations
    module Base
      include Declarations
      
      def register_association(association)
        local_declarations(:associations, []) do |list|
          association.setup(self)
          list << association
        end
      end
      
      def associations
        inherited_declarations(:associations) do |inherited_data|
          inherited_data.inject([]) do |as, local_as|
            as + local_as
          end
        end
      end      

      # Returns association object for a given slotname.
      def association(slotname)
        associations.detect{|a| a.slotname = slotname }
      end
      
    end # Base
  end # Associations
end # StrokeDB
