module StrokeDB
  module Associations
    # TODO: extract this and validations into Declarations 
    module ClassMethods
      def register_association(association)
        @association ||= []
        @association << association
        association.setup(self)
      end
      
      # per-module validations, inheritance chain is not looked up.
      def local_associations
        @associations
      end
      
      # Inherit all the validations
      def associations
        ancestors.inject([]) do |validations, mod|
          contains_associations?(mod) ? associations + mod.local_associations : associations
        end
      end
      
    private
      def contains_associations?(mod)
        mod != Associations && mod.ancestors.include?(Associations)
      end
    end # ClassMethods
  end # Associations
end # StrokeDB
