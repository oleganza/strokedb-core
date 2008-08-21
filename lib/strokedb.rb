require 'rubygems'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'set'
require 'fileutils'
begin
  require 'extlib' 
rescue LoadError => e
  raise e, "Extlib is missing. See git://github.com/sam/extlib.git"
end
require 'strokedb/version'
require 'strokedb/constants'
require 'strokedb/util'
require 'strokedb/plugins'
require 'strokedb/repositories'
require 'strokedb/views'
require 'strokedb/validations'
require 'strokedb/stroke_objects'
