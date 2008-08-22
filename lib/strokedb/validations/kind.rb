module StrokeDB
  module Validations
    module ClassMethods
      def validates_kind_of(slot, options = {})
        # TODO: check the args
        options = {:type => options} unless options.is_a? Hash 
        register_validation(Kind.new({:slotname => slot}.merge(options)))
      end
      alias validate_kind_of validates_kind_of # nobody likes stupid typos
      
    end # ClassMethods
    
    class Kind < BaseSlotValidation
      DEFAULT_OPTIONS = {
        :message => proc {|doc, slotname, validation| 
          "#{slotname} must be kind of #{validation.type_message}" 
        }
      }
      
      attr_accessor :type, :one_of
      
      def initialize(options)
        super(options, DEFAULT_OPTIONS)
        @type     = @options[:type]
        @one_of   = @options[:one_of]
      end
      
      def validate(doc, errors)
        super(doc, errors) do |slotname, value|
          @type && value.kind_of?(@type) ||
          @one_of && @one_of.all?{|t| value.kind_of?(t) }
        end
      end
            
      def type_message
        return @type if @type
        return "one of #{@one_of.inspect}" if @one_of
      end      
      
    end # Kind
  end # Validations
end # StrokeDB
