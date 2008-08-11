module StrokeDB
  module Repositories
    module MarshalHelper

      def encode_doc(doc)
        super(Marshal.dump(doc))
      end
    
      def decode_doc(encoded_doc)
        Marshal.load(super(encoded_doc))
      end
    end
  end # Repositories
end # StrokeDB
