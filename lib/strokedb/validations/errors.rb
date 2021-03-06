module StrokeDB
  module Validations
    class Errors
      include Enumerable
      attr_accessor :doc, :errors
      def initialize(doc)
        @doc = doc
        @errors = []
      end
      
      # Add validation and message or Error object to the list of errors.
      # Returns self.
      def add(validation, message = nil)
        if validation.is_a? Error
          @errors << validation
        else
          @errors << Error.new(validation, message)
        end
        self
      end
      alias push add
      
      # Iterates over each error
      def each(&blk)
        @errors.each(&blk) 
      end
      
      # Returns errors grouped by slot name.
      # Validations without slotname are stored under +nil+ key.
      def by_slot
        @errors.inject({ }) do |hash, error|
          sn = error.slotname
          hash[sn] ||= []
          hash[sn] << error
          hash
        end
      end
      
      def empty?
        @errors.empty?
      end
      
      # Return all error messages
      def messages
        @errors.map{|e| e.message }
      end
      
      # Stores validation object and error message.
      class Error
        attr_accessor :validation, :message
        def initialize(validation, message)
          @validation = validation
          @message = message
        end
        # Returns invalid slot's name (String). 
        # Returns nil if validation doesn't refer to a particular slot.
        def slotname
          @validation.respond_to?(:slotname) ? @validation.slotname : nil
        end
      end
      
    end
  end
end