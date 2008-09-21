require 'set'
require 'fileutils'

# These libs are not published as gems yet.
# git submodule init && git submodule update
begin
  ($:.unshift *(Dir[ File.join( File.dirname(__FILE__), '..', 'vendor', '**', 'lib' ) ].to_a.map {|f| File.expand_path(f) }) ).uniq!
  libs = %w[extlib tokyocabinet-wrapper declarations]
  libs.each do |lib|
    require lib
  end
rescue LoadError => e
  puts "You need submodules #{libs.join(', ')} to be updated. Update now? [y/n]"
  if gets.strip =~ /^y/
    system("git submodule init && git submodule update")
    retry
  end
  raise
end

require 'strokedb/version'
require 'strokedb/constants'
require 'strokedb/util'
require 'strokedb/repositories'
require 'strokedb/views'
require 'strokedb/associations'
require 'strokedb/validations'
require 'strokedb/stroke_objects'
require 'strokedb/document'
