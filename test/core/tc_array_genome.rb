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


class ArrayGenomeTest < Test::Unit::TestCase

	GENOME_SIZE = 20

	context "when created with size=#{GENOME_SIZE}" do
		setup do
			@genome = EvoSynth::ArrayGenome.new(GENOME_SIZE)
		end

		should "#changed be true" do
			assert @genome.changed?
		end

		should "clone returns a new object" do
			my_clone = @genome.clone
			assert_not_equal my_clone.object_id, @genome.object_id
			assert_kind_of EvoSynth::ArrayGenome, my_clone
		end

		should "deep_clone returns a new object" do
			my_clone = @genome.deep_clone
			assert_not_equal my_clone.object_id, @genome.object_id
			assert_kind_of EvoSynth::ArrayGenome, my_clone
		end
	end

	context "after initialized with random values" do
		setup do
			@genome = EvoSynth::ArrayGenome.new(GENOME_SIZE) {EvoSynth.rand_bool}
		end

		should "clone returns a shallow copy" do
			my_clone = @genome.clone
			assert_equal my_clone, @genome
			assert_not_equal  my_clone.object_id, @genome.object_id
		end

		should "deep_clone returns a deep copy" do
			my_clone = @genome.deep_clone
			assert_equal my_clone, @genome
			assert_not_equal  my_clone.object_id, @genome.object_id
		end
	end
	
	context "after #changed is set to true" do
		setup do
			@genome = EvoSynth::ArrayGenome.new(GENOME_SIZE)
			@genome.map! { 1 }
			@genome.changed = true
		end

		should "clone do nothing to changed" do
			my_clone = @genome.clone
			assert my_clone.changed?
		end

		should "deep_clone do nothing to changed" do
			my_clone = @genome.deep_clone
			assert my_clone.changed?
		end
	end

	context "after #changed is set to false" do
		setup do
			@genome = EvoSynth::ArrayGenome.new(GENOME_SIZE)
			@genome.map! { 1 }
			@genome.changed = false
		end

		should "#changed be false" do
			assert !@genome.changed?
		end

		should "sort do nothing" do
			@genome.sort
			assert !@genome.changed?
			@genome.changed = false
		end

		should "reject! set changed to true" do
			@genome.reject! { |foo| foo != nil }
			assert @genome.changed?
			@genome.changed = false
		end

		should "reverse! set changed to true" do
			@genome.reverse!
			assert @genome.changed?
			@genome.changed = false
		end

		should "slice! set changed to true" do
			@genome.slice!(0)
			assert @genome.changed?
			@genome.changed = false
		end

		should "flatten! set changed to true" do
			@genome.flatten!
			assert @genome.changed?
			@genome.changed = false
		end

		should "push set changed to true" do
			@genome.push(2)
			assert @genome.changed?
			@genome.changed = false
		end

		should "pop set changed to true" do
			@genome.pop
			assert @genome.changed?
			@genome.changed = false
		end

		should "sort! set changed to true" do
			@genome.sort!
			assert @genome.changed?
			@genome.changed = false
		end

		should "shift set changed to true" do
			@genome.shift
			assert @genome.changed?
			@genome.changed = false
		end

		should "unshift set changed to true" do
			@genome.unshift("bar")
			assert @genome.changed?
			@genome.changed = false
		end

		should "[]= set changed to true" do
			@genome[0] = "foo"
			assert @genome.changed?
			@genome.changed = false
		end

		should "collect! set changed to true" do
			@genome.collect! { |foo| "foo" }
			assert @genome.changed?
			@genome.changed = false
		end

		should "map! set changed to true" do
			@genome.map! { |foo| "foo" }
			assert @genome.changed?
			@genome.changed = false
		end

		should "<< set changed to true" do
			@genome << "baz"
			assert @genome.changed?
			@genome.changed = false
		end

		should "uniq! set changed to true" do
			@genome.uniq!
			assert @genome.changed?
			@genome.changed = false
		end

		should "clear set changed to true" do
			@genome.clear
			assert @genome.changed?
			@genome.changed = false
		end

		should "clone do nothing to changed" do
			my_clone = @genome.clone
			assert !my_clone.changed?
		end

		should "deep_clone do nothing to changed" do
			my_clone = @genome.deep_clone
			assert !my_clone.changed?
		end
	end

end