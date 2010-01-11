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
require 'test/test_util/test_helper'


class UniformCrossoverTest < Test::Unit::TestCase

	GENOME_SIZE = 100
	PROBABILITY = 0.5
	TIMES = 1000
	DELTA = 0.05
	EXPECTED = PROBABILITY * GENOME_SIZE * TIMES

	context "when run on binary genome (size=#{GENOME_SIZE})" do
		setup do
			@individual_one = TestBinaryIndividual.new(GENOME_SIZE)
			@individual_one.genome.map! { |gene| true }
			@individual_two = TestBinaryIndividual.new(GENOME_SIZE)
			@individual_two.genome.map! { |gene| false }
		end

		context "before recombination is executed" do
			should "all genes of individual one should be true" do
				@individual_one.genome.each { |gene| assert gene }
			end

			should "all genes of individual two should be false" do
				@individual_two.genome.each { |gene| assert !gene }
			end
		end

		context "after recombination is executed #{TIMES} times" do
			setup do
				uniform_crossover = EvoSynth::Recombinations::UniformCrossover.new
				@count = [0, 0]
				TIMES.times do
					child_one, child_two = uniform_crossover.recombine(@individual_one, @individual_two)
					child_one.genome.each { |gene| @count[0] += 1 if !gene }
					child_two.genome.each { |gene| @count[1] += 1 if !gene }
				end
			end

			should "all genes of the parent one should (still) be true" do
				@individual_one.genome.each { |gene| assert gene }
			end

			should "all genes of the parent two should (still) be false" do
				@individual_two.genome.each { |gene| assert !gene }
			end

			should "around #{EXPECTED} genes should have mutated to false (in both children)" do
				assert_in_delta EXPECTED, @count[0], DELTA * EXPECTED
				assert_in_delta EXPECTED, @count[1], DELTA * EXPECTED
			end
		end

	end

end
