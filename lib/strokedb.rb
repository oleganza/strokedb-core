require 'rubygems'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'set'
require 'fileutils'
begin
  require 'extlib' 
rescue LoadError => e
  raise e, "Extlib is missing. See http://github.com/sam/extlib/"
end
begin
  require 'tokyocabinet-wrapper' 
rescue LoadError => e
  raise e, "Tokyocabinet wrapper is missing. See http://github.com/oleganza/tokyocabinet-wrapper/"
end
require 'strokedb/version'
require 'strokedb/constants'
require 'strokedb/util'
require 'strokedb/repositories'
require 'strokedb/views'
require 'strokedb/associations'
require 'strokedb/validations'
require 'strokedb/stroke_objects'
require 'strokedb/metas'
