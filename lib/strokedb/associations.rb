prefix = "strokedb/associations"
require "#{prefix}/base"
require "#{prefix}/belongs_to"
require "#{prefix}/has_many"

module StrokeDB
  module Associations
    def self.included(mod)
      mod.extend(BelongsTo)
      mod.extend(HasMany)
    end
  end
end
