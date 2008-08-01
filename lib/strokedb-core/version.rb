module StrokeDB
  module Core
          MAIN = 0
         MAJOR = 1
         MINOR = 0
    PATCHLEVEL = 0
  
    VERSION = [MAIN.to_s, MAJOR.to_s, MINOR.to_s, PATCHLEVEL.to_s].join('.')
    VERSION_STRING = VERSION + (RUBY_PLATFORM =~ /java/ ? '-java' : '')
  end
end