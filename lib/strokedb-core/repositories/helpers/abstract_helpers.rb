module StrokeDB
  module Core
    module Repositories
      module AbstractHelpers
        
        # Version is generated before save action
        def generate_version(doc)
        end

        # Must accept nil (for new documents)
        def generate_uuid(doc)
        end
      
        # Encodes document before serialization.
        # Use super() to stack serialization layers.
        # Example:
        #   def encode_doc(doc)
        #     super(doc.to_json)  # encode to json, then pass to lower level
        #   end
        # Note: AbstractHelpers define pass-through behaviour to use super() safely.
        def encode_doc(doc)
          doc
        end
        
        # Decodes document after retrieval
        # Use super() to stack serialization layers.
        # Example:
        #   def decode_doc(doc)
        #     JSON.decode(super(doc)) # decodes lower level format, then decodes JSON
        #   end
        # Note: AbstractHelpers define pass-through behaviour to use super() safely.
        def decode_doc(encoded_doc)
          encoded_doc
        end
        
        # Produces a new document instance with the UUID and nothing else.
        def new_document
        end
        
      end
    end # Repositories
  end # Core
end # StrokeDB
