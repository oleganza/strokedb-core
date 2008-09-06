require 'rubygems'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'set'
require 'fileutils'

def git_require(name, url)
  begin
    require name
  rescue LoadError => e
    raise e, "#{name} is missing. See #{url}"
  end  
end

git_require 'extlib',               'http://github.com/sam/extlib/'
git_require 'tokyocabinet-wrapper', 'http://github.com/oleganza/tokyocabinet-wrapper/'
git_require 'declarations',         'http://github.com/oleganza/declarations/'

require 'strokedb/version'
require 'strokedb/constants'
require 'strokedb/util'
require 'strokedb/repositories'
require 'strokedb/views'
require 'strokedb/associations'
require 'strokedb/validations'
require 'strokedb/stroke_objects'
require 'strokedb/document'
