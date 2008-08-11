module StrokeDB
  module Views
    # DefaultKeyEncoder takes primitive types along with arrays and documents.
    # Arrays are encoded recursively with items being space-separated.
    # Note: core classes are extended by method which name is SHA1 UUID of the string: 
    # "StrokeDB::Core::Views::DefaultKeyEncoder"
    # 
    module DefaultKeyCodec
      module CoreExtensions
        class ::NilClass
          STROKEDB_A = "A".freeze
          def a785274d_dccb_53f1_8262_012d28b070ec; STROKEDB_A; end
        end
        class ::FalseClass
          STROKEDB_B = "B".freeze
          def a785274d_dccb_53f1_8262_012d28b070ec; STROKEDB_B; end
        end
        class ::TrueClass
          STROKEDB_C = "C".freeze
          def a785274d_dccb_53f1_8262_012d28b070ec; STROKEDB_C; end
        end
        class ::Integer
          STROKEDB_D1 = "D1".freeze
          STROKEDB_D0 = "D0".freeze
          STROKEDB_N = "N".freeze
          STROKEDB_Ha = "H*".freeze
          # This helps with natural sort order
          # "D<sign><number length (8 hex bytes)><hex>"
          def a785274d_dccb_53f1_8262_012d28b070ec
            hex = self.abs.to_s(16)
            if self >= 0
              STROKEDB_D1 + [ hex.size ].pack(STROKEDB_N).unpack(STROKEDB_Ha)[0] + hex
            else
              s = hex.size
              STROKEDB_D0 + [ 2**32 - s ].pack(STROKEDB_N).unpack(STROKEDB_Ha)[0] + (16**s + self).to_s(16)
            end
          end
        end
        class ::Float
          # Encodes integer part and appends ratio part
          # "D<sign><number length (4 bytes)><hex>.<dec>"
          def a785274d_dccb_53f1_8262_012d28b070ec
            i = self.floor
            r = self - i
            i.a785274d_dccb_53f1_8262_012d28b070ec + r.to_s[1, 666]
          end
        end
        class ::String
          STROKEDB_SPACE_CHAR = " ".freeze
          STROKEDB_KEY_CHAR   = "S".freeze
          def a785274d_dccb_53f1_8262_012d28b070ec
            if self[STROKEDB_SPACE_CHAR]
              split(STROKEDB_SPACE_CHAR).a785274d_dccb_53f1_8262_012d28b070ec
            else
              STROKEDB_KEY_CHAR + self
            end
          end
        end
        class ::Symbol
          def a785274d_dccb_53f1_8262_012d28b070ec
            to_s.a785274d_dccb_53f1_8262_012d28b070ec
          end
        end
        class ::Array
          STROKEDB__ = " ".freeze
          def a785274d_dccb_53f1_8262_012d28b070ec
            flatten.map{|e| e.a785274d_dccb_53f1_8262_012d28b070ec }.join(STROKEDB__)
          end
        end
        class ::Time
          # Index key is in UTC format to provide correct sorting, but lacks timezone info.
          # slot.rb maintains timezone offset and keeps timezone-local time value
          STROKEDB_KEY_CHAR = "T".freeze
          def a785274d_dccb_53f1_8262_012d28b070ec
            STROKEDB_KEY_CHAR + getgm.xmlschema(7)
          end
        end
        class ::Object
          STROKEDB_UUID_CHAR = "@".freeze
          STROKEDB_UUID = "uuid".freeze
          # All other objects must implement ["uuid"] method to be used as keys.
          def a785274d_dccb_53f1_8262_012d28b070ec
            STROKEDB_UUID_CHAR + self[STROKEDB_UUID]
          end
        end
      end
      
      def encode_key(k)
        k.a785274d_dccb_53f1_8262_012d28b070ec
      end
      
      A = "A".freeze
      B = "B".freeze
      C = "C".freeze
      D = "D".freeze
      S = "S".freeze
      T = "T".freeze
      X = "@".freeze
      S_= " ".freeze
      R = (1..-1).freeze
      Cdot  = ".".freeze
      C1    = "1".freeze
      C0dot = "0.".freeze
      
      def decode_key(ek)
        values = ek.split(S_).map do |token|
          pfx = token[0,1]
          case pfx
          when A
            nil
          when B
            false
          when C
            true
          when D
            int, rat = token[10, 666].split(Cdot)
            sign = token[1, 1] == C1 ? 1 : -1
            size = token[2, 8].to_i(16)
            int = int.to_i(16)
            if sign == -1
              size = 2**32 - size
              int  = 16**size - int
            end
            rat ? sign*int + (C0dot + rat).to_f : sign*int
          when S, X
            token[R]
          when T
            Time.xmlschema(token[R]).localtime
          else
            token  # unknown stuff is decoded as a string
          end
        end
        values.size > 1 ? values : values[0]
      end

    end
  end
end
