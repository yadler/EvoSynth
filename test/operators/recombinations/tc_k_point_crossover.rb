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
require './test/test_util/test_helper'


class KPointCrossoverTest < Test::Unit::TestCase

	GENOME_SIZE = 2000
	K = 4

	context "a k-point-crossover (k=#{K}) run on binary genome" do

		setup do
			@recombination = EvoSynth::Recombinations::KPointCrossover.new(K)

			@individual_one = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual_one.genome.map! { |gene| true }
			@individual_two = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual_two.genome.map! { |gene| false }
		end

		context "before k-point-crossover is executed" do

			should "all genes of individual one should be true" do
				@individual_one.genome.each { |gene| assert_equal true, gene }
			end

			should "all genes of individual two should be false" do
				@individual_two.genome.each { |gene| assert_equal false, gene }
			end

		end

		context "after k-point-crossover is executed" do

			setup do
				@child_one, @child_two = @recombination.recombine(@individual_one, @individual_two)
			end

			should "all genes of the parent one should (still) be true" do
				@individual_one.genome.each { |gene| assert_equal true, gene }
			end

			should "all genes of the parent two should (still) be false" do
				@individual_two.genome.each { |gene| assert_equal false, gene }
			end

			should "the genes of the childrens should always be different at the same index" do
				@child_one.genome.each_with_index { |gene, index| assert_equal !gene, @child_two.genome[index] }
			end

		end

	end

end