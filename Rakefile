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
require 'rake/rdoctask'
require 'rcov/rcovtask'


desc "print message"
task :default do
	puts "You have run rake without a task - please choose one of the following:\n\n"
	puts `rake --tasks`
end

package_specification = Gem::Specification.new do |spec|
	spec.required_ruby_version	= '>= 1.9'
	spec.platform				= Gem::Platform::RUBY
	spec.name					= 'evosynth'
	spec.version				= '0.2.0'

	spec.rubyforge_project		= 'evosynth'
	spec.homepage				= 'http://evosynth.rubyforge.org'
	spec.summary				= 'EvoSynth (Evolutionary Computation Synthesizer) is a framework for rapid development and prototyping of evolutionary algorithms.'
	spec.description			= spec.summary
	spec.author					= 'Yves Adler'
	spec.email					= 'yves.adler@googlemail.com'

	spec.has_rdoc				= true
	spec.rdoc_options			= ["--charset", "UTF-8", "--title", "EvoSynth Documentation", "--main", "README", "--line-numbers"]
	spec.extra_rdoc_files		= ["README", "LICENSE", "INSTALL", "docs/FEATURES"]

	# files and dependencies:

	files = FileList['**/*']; files.exclude('.git*'); files.exclude('pkg/*')
	spec.files			= files.to_a
	spec.test_files		= FileList['test/ts_*.rb']
	spec.require_paths	<< 'lib'

	# should these "requirements" become dependencies?
	spec.requirements << 'gnuplot for visualization'
	spec.requirements << 'flay, flog, roodi and rcov gems for code quality analysis'

	spec.add_development_dependency('shoulda', '>=2.10.3')
	spec.add_development_dependency('rake', '>=0.8.7')
end

Rake::GemPackageTask.new(package_specification) do |pkg|
	pkg.need_zip = true
	pkg.need_tar = true
end

Rake::RDocTask.new do |rdoc|
	rdoc.main = "README"
	rdoc.rdoc_dir	= "docs/rdoc"
	rdoc.title		= "EvoSynth Documentation"
	rdoc.options	= ["--charset", "UTF-8", "--line-numbers"]
	rdoc.rdoc_files.include("README", "LICENSE", "INSTALL", "docs/FEATURES", "lib/**/*.rb", "examples/**/*.rb")
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

desc "Analyze the code with roodi (Ruby Object Oriented Design Inferometer)"
task :roodi do
	roodi_output = `roodi 'lib/**/*.rb' 'examples/**/*.rb'`
	puts "ERROR: roodi not found. please install 'gems install roodi'" if $?.exitstatus == 127
	puts roodi_output
end

desc "Analyze for code duplication"
task :flay do
	flay_output = `flay '#{lib_dir}' '#{examples_dir}'`
	puts "ERROR: flay not found. please install 'gems install flay'" if $?.exitstatus != 0
	puts flay_output
end

desc "Analyze for code complexity"
task :flog do
	flog_output = `find lib -name \*.rb | xargs flog -g`
	puts "ERROR: flog not found. please install 'gems install flog'" if $?.exitstatus != 0
	puts flog_output
end

# Shortcuts for examples and benchmark

desc "Run all examples"
task :run_examples do
	example_files = FileList["examples/**/*.rb"]
	$:.unshift File.expand_path("../lib", __FILE__)
	example_files.each do |example_file|
		puts "\nRunning example : #{example_file}\n\n"
		load example_file
	end
end

desc "Run all benchmarks"
task :run_benchmarks do
	$:.unshift File.expand_path("../lib", __FILE__)
	load 'benchmarks/decoder_benchmark.rb'
	load 'benchmarks/mutation_benchmark.rb'
	load 'benchmarks/recombination_benchmark.rb'
	load 'benchmarks/selection_benchmark.rb'
end


Rcov::RcovTask.new do |t|
#	t.libs << "test"
	t.test_files = FileList['test/ts_*.rb']
	t.verbose = true
end
