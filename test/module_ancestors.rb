#!/usr/bin/env ruby

class Module
  # Default implementation doesn't collect all possible ancestors.
  alias not_all_ancestors ancestors
  def ancestors(collected = [])
    collected << self
    (not_all_ancestors - collected).inject(collected) do |c, a|
      (c | a.ancestors(c))
    end
  end
end

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

p([A1, A2, B1, B2].map{|m| m.not_all_ancestors == m.ancestors })

puts(C.ancestors - C.not_all_ancestors == [ A1 ])
puts(C.ancestors == [C, B2, A2, B1, A1, Object, Kernel])
puts(C.not_all_ancestors == [C, B2, A2, B1, Object, Kernel])
