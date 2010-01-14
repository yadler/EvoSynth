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


class ArithmeticCrossoverTest < Test::Unit::TestCase

	GENOME_SIZE = 100
	DELTA = 0.05

	context "a arithmetic crossover run on a Fixnum genome" do

		setup do
			interpolation_function = EvoSynth::Recombinations::ArithmeticCrossover::INTERPOLATE_NUMBERS
			@recombination = EvoSynth::Recombinations::ArithmeticCrossover.new(interpolation_function)

			genome_one, genome_two = [], []
			GENOME_SIZE.times { |i| genome_one << i; genome_two << GENOME_SIZE - i }
			@individual_one = TestGenomeIndividual.new(genome_one)
			@individual_two = TestGenomeIndividual.new(genome_two)
		end

		context "before recombination is executed" do

			should "each index added should be == GENOME_SIZE" do
				GENOME_SIZE.times { |i| assert_equal GENOME_SIZE, @individual_one.genome[i] + @individual_two.genome[i] }
			end

		end

		context "after recombination is executed" do

			setup do
				@child_one, @child_two = @recombination.recombine(@individual_one, @individual_two)
			end

			should "each index of the parents added should (still) be == GENOME_SIZE" do
				GENOME_SIZE.times { |i| assert_equal GENOME_SIZE, @individual_one.genome[i] + @individual_two.genome[i] }
			end

			should "the average value of all genes should be at #{GENOME_SIZE/2}" do
				sum = 0
				@child_one.genome.each { |gene| sum += gene }
				assert_in_delta GENOME_SIZE/2, sum / GENOME_SIZE, DELTA * GENOME_SIZE
				sum = 0
				@child_two.genome.each { |gene| sum += gene }
				assert_in_delta GENOME_SIZE/2, sum / GENOME_SIZE, DELTA * GENOME_SIZE
			end

		end

	end

end