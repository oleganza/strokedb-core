module StrokeDB
  module Validations
    module InstanceMethods
      def save
        p self.class.validations
        super
      end
    end
  end # Validations
end # StrokeDB
