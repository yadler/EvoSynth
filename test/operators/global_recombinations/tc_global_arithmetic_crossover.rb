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
require_relative '../../../test/test_util/test_helper'


class GlobalArithmeticCrossoverTest < Test::Unit::TestCase

	GENOME_SIZE = 100
	TIMES = 1000
	DELTA = 0.01

	context "when run on binary genome (size=#{GENOME_SIZE})" do
		setup do
			@population = EvoSynth::Population.new
			individual_one = TestArrayGenomeIndividual.new([1.0]*GENOME_SIZE)
			individual_two = TestArrayGenomeIndividual.new([2.0]*GENOME_SIZE)

			@population << individual_one << individual_two
		end

		context "before recombination is executed" do
			should "all genes of individual one should be 1.0" do
				@population[0].genome.each { |gene| assert_equal 1.0, gene }
			end

			should "all genes of individual two should be 2.0" do
				@population[1].genome.each { |gene| assert_equal 2.0, gene }
			end
		end

		context "after recombination is executed #{TIMES} times" do
			setup do
				@recombination = EvoSynth::GlobalRecombinations::GlobalArithmeticCrossover.new
				@child = @recombination.recombine(@population)
			end

			should "all genes of the parent one should (still) be 1.0" do
				@population[0].genome.each { |gene| assert_equal 1.0, gene }
			end

			should "all genes of the parent two should (still) be 2.0" do
				@population[1].genome.each { |gene| assert_equal 2.0, gene }
			end

			should "all genes of the child should equal 0.5" do
				@child.genome.each { |gene| assert_equal 1.5, gene }
			end

			should "deep_clone returns a new deep copy" do
				my_clone = @recombination.deep_clone
				assert_not_equal my_clone.object_id, @recombination.object_id
				assert_kind_of EvoSynth::GlobalRecombinations::GlobalArithmeticCrossover, my_clone
			end
		end
	end
end
