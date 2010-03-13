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


class DiversityTest < Test::Unit::TestCase

	context "when test with example in Weicker 2007, page 230" do

		setup do
			@i1 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,1,1,0,1]) )
			@i2 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([1,1,0,0,0]) )
			@i3 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,0,1,1,1]) )
			@i4 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([1,0,1,0,1]) )
			@i5 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([1,1,0,1,1]) )
			@i6 = EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new([0,0,0,0,0]) )
			@pop = EvoSynth::Population.new([@i1, @i2, @i3, @i4, @i5, @i6])
		end

		should "Benchmark.hamming_distance(genome_one, genome_two) be correct" do
			assert_equal(0, EvoSynth::Benchmark.hamming_distance([0,1,0,1], [0,1,0,1]))
			assert_equal(1, EvoSynth::Benchmark.hamming_distance([0,1,0,1], [0,1,1,1]))
			assert_equal(2, EvoSynth::Benchmark.hamming_distance([0,1,0,1], [0,1,1,0]))
			assert_equal(3, EvoSynth::Benchmark.hamming_distance([0,1,0,1], [0,0,1,0]))
			assert_equal(4, EvoSynth::Benchmark.hamming_distance([0,1,0,1], [1,0,1,0]))
		end

		should "the hamming distance diversity for the population be 86/30" do
			assert_equal(86.0/30.0, EvoSynth::Benchmark.diversity_hamming_distance(@pop))
		end
	end

end