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


require 'shoulda'

require 'evosynth'
require 'test/util/test_helper'


class ArrayGenomeTest < Test::Unit::TestCase

	GENOME_SIZE = 20

	context "when created with size=#{GENOME_SIZE}" do
		setup do
			@genome = EvoSynth::ArrayGenome.new(GENOME_SIZE)
		end

		should "#changed be true" do
			assert @genome.changed
		end

		should "#overwrite_methods! should be private" do
			assert_raise_kind_of(NoMethodError) { @genome.overwrite_methods! }
		end
	end

	context "after #changed is set to false" do
		setup do
			@genome = EvoSynth::ArrayGenome.new(GENOME_SIZE)
			@genome.map! { 1 }
			@genome.changed = false
		end

		should "#changed be false" do
			assert !@genome.changed
		end

		should "sort do nothing" do
			@genome.sort
			assert !@genome.changed
			@genome.changed = false
		end

		should "reject! set changed to true" do
			@genome.reject! { |foo| foo != nil }
			assert @genome.changed
			@genome.changed = false
		end

		should "reverse! set changed to true" do
			@genome.reverse!
			assert @genome.changed
			@genome.changed = false
		end

		should "slice! set changed to true" do
			@genome.slice!(0)
			assert @genome.changed
			@genome.changed = false
		end

		should "flatten! set changed to true" do
			@genome.flatten!
			assert @genome.changed
			@genome.changed = false
		end

		should "push set changed to true" do
			@genome.push(2)
			assert @genome.changed
			@genome.changed = false
		end

		should "pop set changed to true" do
			@genome.pop
			assert @genome.changed
			@genome.changed = false
		end

		should "sort! set changed to true" do
			@genome.sort!
			assert @genome.changed
			@genome.changed = false
		end

		should "shift set changed to true" do
			@genome.shift
			assert @genome.changed
			@genome.changed = false
		end

		should "unshift set changed to true" do
			@genome.unshift("bar")
			assert @genome.changed
			@genome.changed = false
		end

		should "[]= set changed to true" do
			@genome[0] = "foo"
			assert @genome.changed
			@genome.changed = false
		end

		should "collect! set changed to true" do
			@genome.collect! { |foo| "foo" }
			assert @genome.changed
			@genome.changed = false
		end

		should "map! set changed to true" do
			@genome.map! { |foo| "foo" }
			assert @genome.changed
			@genome.changed = false
		end

		should "<< set changed to true" do
			@genome << "baz"
			assert @genome.changed
			@genome.changed = false
		end

		should "reject! set changed to true" do
			@genome.reject! { |foo| foo != nil }
			assert @genome.changed
			@genome.changed = false
		end

		should "uniq! set changed to true" do
			@genome.uniq!
			assert @genome.changed
			@genome.changed = false
		end

		should "clear set changed to true" do
			@genome.clear
			assert @genome.changed
			@genome.changed = false
		end

	end

end