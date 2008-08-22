module StrokeDB
  module Validations    
    class BaseSlotValidation
      DEFAULT_OPTIONS = {
        :if      => true,
        :unless  => false
      }
      
      attr_accessor :slotname, :message, :if, :unless, :options
      
      def initialize(options, defaults)
        # First, we use user-defined defaults to let him override our defaults.
        @options = OptionsHash!(OptionsHash(options, defaults), DEFAULT_OPTIONS)
        @slotname = @options.require(:slotname).to_s
        m         = @options.require(:message)
        @message  = m.respond_to?(:call) ? m : (Proc.new{|*a| m })
        @if       = procify(@options.require(:if))
        @unless   = procify(@options.require(:unless))
      end
      
      def validate(doc, errors)
        slotname = @slotname
        
        return nil unless @if.call(doc, slotname)
        return nil if @unless.call(doc, slotname)
        return nil if yield(slotname, doc[slotname])
        
        errors.add(self, @message.call(doc, slotname, self))
        errors
      end
      
    private
      
      def procify(value)
        return value if value.respond_to?(:call)
        return (Proc.new{|*args| value }) if value == true || value == false
        Proc.new do |doc, slotname|
          doc.send(value)
        end
      end
    
    end # BaseSlotValidation
  end # Validations
end # StrokeDB
