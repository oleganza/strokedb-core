module StrokeDB
  VERSION = '0.1.0' unless defined?(StrokeDB::Core::VERSION)

  # StrokeDB::Core::RELEASE meanings:
  # 'dev'   : unreleased
  # 'pre'   : pre-release Gem candidates
  #  nil    : released
  # You should never check in to trunk with this changed.  It should
  # stay 'dev'.  Change it to nil in release tags.
  RELEASE = 'dev' unless defined?(StrokeDB::Core::RELEASE)
end
