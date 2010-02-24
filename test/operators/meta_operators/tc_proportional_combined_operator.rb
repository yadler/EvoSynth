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


class ProportionalCombinedOperatorTest < Test::Unit::TestCase

	GENOME_SIZE = 20
	ITERATIONS = 1000
	DELTA = 0.05

	context "when run on binary genome (size=#{GENOME_SIZE}) without a mutation" do
		setup do
			@individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual.genome.map! { |gene| true }
			@operator = EvoSynth::MetaOperators::ProportionalCombinedOperator.new
		end

		should "raise a exception" do
			assert_raise(RuntimeError) { mutated = @operator.mutate(@individual) }
		end
	end

	context "when run on binary genome (size=#{GENOME_SIZE}) with two recombinations" do
		setup do
			@individual_a= TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual_a.genome.map! { |gene| true }
			@individual_b = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual_b.genome.map! { |gene| true }
			@combinded_operator = EvoSynth::MetaOperators::ProportionalCombinedOperator.new(TestRecombinationA.new, TestRecombinationB.new)
		end

		should "both recombinations should have been used (nearly) equally often" do
			count_a, count_b = 0, 0

			ITERATIONS.times do
				recombined = @combinded_operator.recombine(@individual_a, @individual_b)
				count_a += 1 if recombined == ["RecA", "RecA"]
				count_b += 1 if recombined == ["RecB", "RecB"]
			end

			assert_equal ITERATIONS, count_a + count_b
			assert_in_delta ITERATIONS/2, count_a, DELTA * ITERATIONS
			assert_in_delta ITERATIONS/2, count_b, DELTA * ITERATIONS
		end
	end

	context "when run on binary genome (size=#{GENOME_SIZE}) with two mutations (alternative constructor)" do
		setup do
			@individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual.genome.map! { |gene| true }
			@combinded_operator = EvoSynth::MetaOperators::ProportionalCombinedOperator.new(TestMutationA.new, TestMutationB.new)
		end

		should "both mutations should have been used (nearly) equally often" do
			count_a, count_b = 0, 0

			ITERATIONS.times do
				mutated = @combinded_operator.mutate(@individual)
				count_a += 1 if mutated == "A"
				count_b += 1 if mutated == "B"
			end

			assert_equal ITERATIONS, count_a + count_b
			assert_in_delta ITERATIONS/2, count_a, DELTA * ITERATIONS
			assert_in_delta ITERATIONS/2, count_b, DELTA * ITERATIONS
		end
	end

	context "when run on binary genome (size=#{GENOME_SIZE}) with two mutations (alternative constructor)" do
		setup do
			@individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual.genome.map! { |gene| true }
			@combinded_operator = EvoSynth::MetaOperators::ProportionalCombinedOperator.new(TestMutationA.new, TestMutationB.new)
		end

		should "both mutations should have been used (nearly) equally often" do
			count_a, count_b = 0, 0

			ITERATIONS.times do
				mutated = @combinded_operator.mutate(@individual)
				count_a += 1 if mutated == "A"
				count_b += 1 if mutated == "B"
			end

			assert_equal ITERATIONS, count_a + count_b
			assert_in_delta ITERATIONS/2, count_a, DELTA * ITERATIONS
			assert_in_delta ITERATIONS/2, count_b, DELTA * ITERATIONS
		end
	end

	context "when run on binary genome (size=#{GENOME_SIZE}) with two mutations" do
		setup do
			@individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual.genome.map! { |gene| true }
			@combinded_operator = EvoSynth::MetaOperators::ProportionalCombinedOperator.new
			@combinded_operator << TestMutationA.new
			@combinded_operator << TestMutationB.new
		end

		should "both mutations should have been used (nearly) equally often" do
			count_a, count_b = 0, 0

			ITERATIONS.times do
				mutated = @combinded_operator.mutate(@individual)
				count_a += 1 if mutated == "A"
				count_b += 1 if mutated == "B"
			end

			assert_equal ITERATIONS, count_a + count_b
			assert_in_delta ITERATIONS/2, count_a, DELTA * ITERATIONS
			assert_in_delta ITERATIONS/2, count_b, DELTA * ITERATIONS
		end
	end

	context "when run with three mutations with different possibilities" do
		setup do
			@individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual.genome.map! { |gene| true }
			@combinded_operator = EvoSynth::MetaOperators::ProportionalCombinedOperator.new
			@combinded_operator.add_with_possibility(TestMutationA.new, 0.5)
			@combinded_operator.add_with_possibility(TestMutationB.new, 0.25)
			@combinded_operator.add_with_possibility(TestMutationC.new, 0.25)
		end

		should "the mutations should have been used according to their possibilities" do
			count_a, count_b, count_c = 0, 0, 0

			ITERATIONS.times do
				mutated = @combinded_operator.mutate(@individual)
				count_a += 1 if mutated == "A"
				count_b += 1 if mutated == "B"
				count_c += 1 if mutated == "C"
			end

			assert_equal ITERATIONS, count_a + count_b + count_c
			assert_in_delta ITERATIONS/2, count_a, DELTA * ITERATIONS
			assert_in_delta ITERATIONS/4, count_b, DELTA * ITERATIONS
			assert_in_delta ITERATIONS/4, count_c, DELTA * ITERATIONS
		end
	end
end