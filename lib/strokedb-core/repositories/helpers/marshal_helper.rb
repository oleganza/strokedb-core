module StrokeDB
  module Core
    module Repositories
      module MarshalHelper

        def encode_doc(doc)
          Marshal.dump(doc)
        end
      
        def decode_doc(encoded_doc)
          Marshal.load(encoded_doc)
        end
      end
    end # Repositories
  end # Core
end # StrokeDB
