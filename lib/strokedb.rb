require 'rubygems'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift( File.expand_path(File.join(File.dirname(__FILE__), 'strokedb')) ).uniq!

require 'set'
require 'fileutils'
require 'strokedb/version'
require 'strokedb/constants'
require 'strokedb/util'
require 'strokedb/plugins'
require 'strokedb/repositories'
require 'strokedb/views'
require 'strokedb/stroke_objects'
