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


class ShiftingMutationTest < Test::Unit::TestCase

	GENOME_SIZE = 20

	context "a shifting mutation run on binary genome (size=#{GENOME_SIZE})" do

		setup do
			@mutation = EvoSynth::Mutations::ShiftingMutation.new
			@individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
			GENOME_SIZE.times { |index| @individual.genome[index] = (index % 2 == 1) ? 0 : 1 }
		end

		context "before mutation is executed" do

			should "genes should alternate between 0 and 1" do
				previous = 0
				@individual.genome.each do |gene|
					assert_not_equal previous, gene
					previous = gene
				end
			end

			should "the count of 0's and 1's should be the same" do
				count_ones, count_zeros = 0, 0
				@individual.genome.each { |gene| gene == 0 ? count_zeros += 1 : count_ones += 1 }
				assert_equal count_ones, count_zeros
			end
		end

		context "after mutations is executed" do

			should "the count of 0's and 1's should still be the same" do
				mutated = @mutation.mutate(@individual)
				count_ones, count_zeros = 0, 0
				mutated.genome.each { |gene| gene == 0 ? count_zeros += 1 : count_ones += 1 }
				assert_equal count_ones, count_zeros
			end

		end

	end

end
