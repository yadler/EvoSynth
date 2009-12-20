#    Copyright (C) 2009 Yves Adler <yves.adler@googlemail.com>
#
#    This file is part of EvoSynth, a framework for rapid prototyping of
#    evolutionary and genetic algorithms.
#
#    EvoSynth is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    EvoSynth is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with EvoSynth.  If not, see <http://www.gnu.org/licenses/>.

# Author::    Yves Adler (mailto:yves.adler@googlemail.com)
# Copyright:: Copyright (C) 2009 Yves Adler
# License::   LGPLv3

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

lib_dir = File.expand_path("lib")
test_dir = File.expand_path("tests")

Rake::TestTask.new do |test|
	test.libs = [lib_dir, test_dir]
	test.test_files = FileList["tests/tc_*.rb"]
	test.verbose = true
end

desc "Run the specs under spec"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--format', "nested"]
  t.spec_files = FileList['spec/*_spec.rb']
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