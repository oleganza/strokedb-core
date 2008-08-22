#!/usr/bin/env ruby

module A1; end
module A2; end

module B1
end

module B2
  include A2
end

class C
  include B1
  include B2
end

module B1
  include A1
end

# Where's module A1?
p C.ancestors # => [C, B2, A2, B1, Object, Kernel]
