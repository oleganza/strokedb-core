class ::Module
  # Default implementation doesn't collect all possible ancestors.
  def absolutely_all_ancestors(collected = [])
    collected << self
    (ancestors - collected).inject(collected) do |c, a|
      (c | a.absolutely_all_ancestors(c))
    end
  end
end
