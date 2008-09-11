require "rake"
require "rake/clean"
require "rake/gempackagetask"
require "rake/rdoctask"
require "rake/testtask"
require "spec/rake/spectask"
require "fileutils"

def __DIR__
  File.dirname(__FILE__)
end

include FileUtils

require "lib/strokedb/version"

GEM_NAME = "strokedb"
GEM_VERSION = StrokeDB::VERSION

def sudo
  ENV['STROKEDB_SUDO'] ||= "sudo"
  sudo = windows? ? "" : ENV['STROKEDB_SUDO']
end

def windows?
  (PLATFORM =~ /win32|cygwin/) rescue nil
end

def install_home
  ENV['GEM_HOME'] ? "-i #{ENV['GEM_HOME']}" : ""
end

##############################################################################
# Packaging & Installation
##############################################################################
CLEAN.include ["**/.*.sw?", "pkg", "lib/*.bundle", "*.gem", "doc/rdoc", ".config", "coverage", "cache"]

desc "Run the specs."
task :default => :specs

task :strokedb => [:clean, :rdoc, :package]

spec = Gem::Specification.new do |s|
  s.name         = GEM_NAME
  s.version      = GEM_VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Oleg Andreev, Yurii Rashkovskii"
  s.email        = "oleganza@gmail.com, yrashk@gmail.com"
  s.homepage     = "http://strokedb.com/"
  s.summary      = "StrokeDB. Distributed document-oriented database."
  s.bindir       = "bin"
  s.description  = s.summary
  s.executables  = %w( strokedb )
  s.require_path = "lib"
  s.files        = %w( MIT-LICENSE README Rakefile TODO ) + Dir["{docs,bin,spec,lib,examples,script}/**/*"]

  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w( README MIT-LICENSE TODO )
  #s.rdoc_options     += RDOC_OPTS + ["--exclude", "^(app|uploads)"]

  # Dependencies
  s.add_dependency "RubyInline"
  s.add_dependency "uuidtools"
  s.add_dependency "rake"
  s.add_dependency "json_pure"
  s.add_dependency "rspec"
  s.add_dependency "rack"
  # Requirements
  s.requirements << "install the json gem to get faster json parsing"
  s.required_ruby_version = ">= 1.8.4"
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc "Run :package and install the resulting .gem"
task :install => :package do
  sh %{#{sudo} gem install #{install_home} --local pkg/#{GEM_NAME}-#{GEM_VERSION}.gem --no-rdoc --no-ri}
end

#desc "Run :package and install the resulting .gem with jruby"
#task :jinstall => :package do
#  sh %{#{sudo} jruby -S gem install #{install_home} pkg/#{GEM_NAME}-#{GEM_VERSION}.gem --no-rdoc --no-ri}
#end

desc "Run :clean and uninstall the .gem"
task :uninstall => :clean do
  sh %{#{sudo} gem uninstall #{GEM_NAME}}
end
