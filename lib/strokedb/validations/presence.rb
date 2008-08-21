module StrokeDB
  module Validations
    module ClassMethods
      # Validates that the specified attributes are not blank (as defined by Object#blank?).
      #
      # Configuration options:
      # * <tt>message</tt> - A custom error message (default is: "can't be blank.")
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
    
    class Presence
      DEFAULT_OPTIONS = {
        :message => proc { |doc, slotname| "#{slotname} can't be blank" },
        :boolean => false,
        :if      => true,
        :unless  => false
      }
      
      attr_accessor :slotname, :message, :if, :unless, :boolean, :options
      
      def initialize(options)
        @options = OptionsHash(options.dup, DEFAULT_OPTIONS)
        @slotname = @options.require(:slotname).to_s
        @boolean  = @options.require(:boolean)
        m         = @options.require(:message)
        @message  = m.respond_to?(:call) ? m : (Proc.new{|*a| m })
        @if       = procify(@options.require(:if))
        @unless   = procify(@options.require(:unless))
      end
      
      def validate(doc, errors)
        slotname = @slotname
        
        return nil unless @if.call(doc, slotname)
        return nil if @unless.call(doc, slotname)

        value = doc[slotname]
        blank = value.blank?
        return nil if !blank || value == false && @boolean
        
        errors.add(self, @message.call(doc, slotname))
        errors
      end
      
      #
      # Serialization
      #
      
      def marshal_dump
        @options.dup
      end
      
      def marshal_load(options)
        initialize(options)
      end
      
    private
      
      def procify(value)
        return value if value.respond_to?(:call)
        return (Proc.new{|*args| value }) if value == true || value == false
        Proc.new do |doc, slotname|
          doc.send(value)
        end
      end
    
    end # Presence
  end # Validations
end # StrokeDB
