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


class ExchangeMutationTest < Test::Unit::TestCase

	MAX_NUM = 20

	context "when run on a permutation genome (size=#{MAX_NUM})" do
		setup do
			@individual = TestArrayGenomeIndividual.new((0..MAX_NUM).to_a)
		end

		context "before mutation is executed" do
			should "the genes should be ordered from 0 to #{MAX_NUM}" do
				prev = -1
				@individual.genome.each { |gene| assert_equal prev + 1, gene; prev = gene }
			end
		end

		context "after exchange mutation is executed" do
			setup do
				mutation = EvoSynth::Mutations::ExchangeMutation.new
				@mutated = mutation.mutate(@individual)
			end

			should "the genes of the parent should (still) be ordered from 0 to #{MAX_NUM}" do
				prev = -1
				@individual.genome.each { |gene| assert_equal prev + 1, gene; prev = gene }
			end

			should "two genes should not be in order" do
				failed = 0
				@mutated.genome.each_with_index { |gene, index| failed += 1 if gene != @individual.genome[index] }
				assert_equal 2, failed
			end
		end
	end

	context "when run on a permutation genome (size=#{MAX_NUM}) with swap_count = 3" do
		setup do
			@individual = TestArrayGenomeIndividual.new((0..MAX_NUM).to_a)
		end

		context "before mutation is executed" do
			should "the genes should be ordered from 0 to #{MAX_NUM}" do
				prev = -1
				@individual.genome.each { |gene| assert_equal prev + 1, gene; prev = gene }
			end
		end

		context "after exchange mutation is executed" do
			setup do
				mutation = EvoSynth::Mutations::ExchangeMutation.new(3)
				@mutated = mutation.mutate(@individual)
			end

			should "the genes of the parent should (still) be ordered from 0 to #{MAX_NUM}" do
				prev = -1
				@individual.genome.each { |gene| assert_equal prev + 1, gene; prev = gene }
			end

			should "three genes should not be in order" do
				failed = 0
				@mutated.genome.each_with_index { |gene, index| failed += 1 if gene != @individual.genome[index] }
				assert_equal 3, failed
			end
		end
	end

	context "when run on a permutation genome (size=#{MAX_NUM}) with swap_count = 4" do
		setup do
			@individual = TestArrayGenomeIndividual.new((0..MAX_NUM).to_a)
		end

		context "before mutation is executed" do
			should "the genes should be ordered from 0 to #{MAX_NUM}" do
				prev = -1
				@individual.genome.each { |gene| assert_equal prev + 1, gene; prev = gene }
			end
		end

		context "after exchange mutation is executed" do
			setup do
				mutation = EvoSynth::Mutations::ExchangeMutation.new(4)
				@mutated = mutation.mutate(@individual)
			end

			should "the genes of the parent should (still) be ordered from 0 to #{MAX_NUM}" do
				prev = -1
				@individual.genome.each { |gene| assert_equal prev + 1, gene; prev = gene }
			end

			should "three genes should not be in order" do
				failed = 0
				@mutated.genome.each_with_index { |gene, index| failed += 1 if gene != @individual.genome[index] }
				assert_equal 4, failed
			end
		end
	end
end