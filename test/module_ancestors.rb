#!/usr/bin/env ruby

class Module
  def all_ancestors(collected = [])
    collected << self
    (ancestors - collected).inject(collected) do |c, a|
      (c | a.all_ancestors(c))
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

p([A1, A2, B1, B2].map{|m| m.all_ancestors == m.ancestors })

puts(C.all_ancestors - C.ancestors == [ A1 ])
puts(C.all_ancestors == [C, B2, A2, B1, A1, Object, Kernel])
puts(C.ancestors == [C, B2, A2, B1, Object, Kernel])
