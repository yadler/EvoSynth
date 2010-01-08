#	Copyright (c) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
#
#	Permission is hereby granted, free of charge, to any person
#	obtaining a copy of this software and associated documentation
#	files (the "Software"), to deal in the Software without
#	restriction, including without limitation the rights to use,
#	copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the
#	Software is furnished to do so, subject to the following
#	conditions:
#
#	The above copyright notice and this permission notice shall be
#	included in all copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#	OTHER DEALINGS IN THE SOFTWARE.


require 'rake/gempackagetask'
require 'rake/testtask'
require 'spec/rake/spectask'

PKG_NAME = "evosynth"
PKG_VERSION = "0.1.0"

package_specification = Gem::Specification.new do |spec|
	spec.platform	= Gem::Platform::RUBY
	spec.name		= PKG_NAME
	spec.version	= PKG_VERSION

	spec.summary	= "EvoSynth is a framework for rapid prototyping of evolutionary and genetic algorithms"
	spec.author		= "Yves Adler"
	spec.email		= "yves.adler@googlemail.com"

	files = FileList["**/*"]
	files.exclude ".git*"
	files.exclude "pkg/*"
	spec.files			= files.to_a

	spec.require_paths	<< "lib"

	spec.has_rdoc			= true
	spec.extra_rdoc_files	= ["COPYING"]
end

Rake::GemPackageTask.new(package_specification) do |pkg|
	pkg.need_zip = true
	pkg.need_tar = true
end

desc "build latest gem package"
task :package do
	Rake::Task["pkg/#{PKG_NAME}-#{PKG_VERSION}.gem"].invoke
end

desc "print message"
task :default do
	puts "You have run rake without a task - please run"
	puts "rake --tasks"
end

# Test tasks and code quality stuff:

task :quality => [:test, :flog, :flay, :roodi]

lib_dir = File.expand_path("lib")
examples_dir = File.expand_path("examples")
test_dir = File.expand_path("test")

Rake::TestTask.new do |test|
	test.libs = [lib_dir, test_dir]
	test.test_files = FileList["test/ts_*.rb"]
	test.verbose = true
end

# FIXME: this is deprecated and should be killed sometime
desc "Run the specs under spec"
Spec::Rake::SpecTask.new do |rspec|
  rspec.spec_opts = ['--format', "nested"]
  rspec.spec_files = FileList['spec/*_spec.rb']
end

desc "Analyze the code with roodi (Ruby Object Oriented Design Inferometer)"
task :roodi do
	roodi_output = `roodi 'lib/**/*.rb' 'examples/**/*.rb'`
	puts "ERROR: roodi not found. please install 'gems install roodi'" if $?.exitstatus == 127
	puts roodi_output
end

desc "Analyze for code duplication"
task :flay do
	flay_output = `flay #{lib_dir} #{examples_dir}`
	puts "ERROR: flay not found. please install 'gems install flay'" if $?.exitstatus != 0
	puts flay_output
end

desc "Analyze for code complexity"
task :flog do
	flog_output = `find lib -name \*.rb | xargs flog -g`
	puts "ERROR: flog not found. please install 'gems install flog'" if $?.exitstatus != 0
	puts flog_output
end
