require 'rubygems'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift( File.expand_path(File.join(File.dirname(__FILE__), 'strokedb-core')) ).uniq!

require 'set'
require 'fileutils'
require 'strokedb-core/version'
require 'strokedb-core/constants'
require 'strokedb-core/util'
require 'strokedb-core/repositories'
require 'strokedb-core/stroke_objects'
