require 'set'
require 'fileutils'

# These libs are not published as gems yet.
# git submodule init && git submodule update
($:.unshift *(Dir[ File.join( File.dirname(__FILE__), '..', 'vendor', '**', 'lib' ) ].to_a.map {|f| File.expand_path(f) }) ).uniq!
require 'extlib'
require 'tokyocabinet-wrapper'
require 'declarations'

require 'strokedb/version'
require 'strokedb/constants'
require 'strokedb/util'
require 'strokedb/repositories'
require 'strokedb/views'
require 'strokedb/associations'
require 'strokedb/validations'
require 'strokedb/stroke_objects'
require 'strokedb/document'
