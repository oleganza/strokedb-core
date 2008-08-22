module StrokeDB
  module Validations
    module ClassMethods
      # Validates that the specified attributes are not blank (as defined by Object#blank?).
      #
      # Configuration options:
      # * <tt>message</tt> - A custom error message (default is: proc{|d,s| "#{s} can't be blank." })
      # * <tt>boolean</tt> - Skips validation if slot is +false+.
      # * <tt>if</tt> - Specifies a method or slot name to call to determine if the validation should
      #   occur (e.g. :if => :allow_validation, or :if => 'signup_step_less_than_three').  The
      #   method result or slot should be equal to a true or false value.
      # * <tt>unless</tt> - Specifies a method or slot name to call to determine if the validation should
      #   not occur (e.g. :unless => :skip_validation, or :unless => 'signup_step_less_than_three').  The
      #   method result or slot should be equal to a true or false value.
      #
      def validates_presence_of(slot, options = {})
        # TODO: check the args
        register_validation(Presence.new({:slotname => slot}.merge(options)))
      end
      alias validate_presence_of validates_presence_of # nobody likes stupid typos
      
    end # ClassMethods
    
    class Presence < BaseSlotValidation
      DEFAULT_OPTIONS = {
        :message => proc { |doc, slotname, validation| "#{slotname} can't be blank" },
        :boolean => false      
      }
      
      attr_accessor :boolean
      
      def initialize(options)
        super(options, DEFAULT_OPTIONS)
        @boolean  = @options.require(:boolean)
      end
      
      def validate(doc, errors)
        super(doc, errors) do |slotname, value|
          !value.blank? || value == false && @boolean
        end
      end
    
    end # Presence
  end # Validations
end # StrokeDB
