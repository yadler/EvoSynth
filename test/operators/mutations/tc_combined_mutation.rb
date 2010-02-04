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


class TestMutationA
	def mutate(individual)
		"A"
	end
	def to_s
		"TestMutationA"
	end
end


class TestMutationB
	def mutate(individual)
		"B"
	end
	def to_s
		"TestMutationB"
	end
end


class TestMutationC
	def mutate(individual)
		"C"
	end
	def to_s
		"TestMutationC"
	end
end


class CombinedMutationTest < Test::Unit::TestCase

	GENOME_SIZE = 20
	ITERATIONS = 1000
	DELTA = 0.05

	context "when run on binary genome (size=#{GENOME_SIZE}) without a mutation" do
		setup do
			@individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual.genome.map! { |gene| true }
			@mutation = EvoSynth::Mutations::CombinedMutation.new
		end

		should "mutated individual equal its parent" do
			mutated = @mutation.mutate(@individual)
			assert_equal @individual, mutated
		end
	end

	context "when run on binary genome (size=#{GENOME_SIZE}) with two mutations (constructor)" do
		setup do
			@individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
			@individual.genome.map! { |gene| true }
			@combinded_mutation = EvoSynth::Mutations::CombinedMutation.new(TestMutationA.new, TestMutationB.new)
		end

		should "both mutations should have been used (nearly) equally often" do
			count_a, count_b = 0, 0

			ITERATIONS.times do
				mutated = @combinded_mutation.mutate(@individual)
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
			@combinded_mutation = EvoSynth::Mutations::CombinedMutation.new
			@combinded_mutation << TestMutationA.new
			@combinded_mutation << TestMutationB.new
		end

		should "both mutations should have been used (nearly) equally often" do
			count_a, count_b = 0, 0

			ITERATIONS.times do
				mutated = @combinded_mutation.mutate(@individual)
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
			@combinded_mutation = EvoSynth::Mutations::CombinedMutation.new
			@combinded_mutation.add_with_possibility(TestMutationA.new, 0.5)
			@combinded_mutation.add_with_possibility(TestMutationB.new, 0.25)
			@combinded_mutation.add_with_possibility(TestMutationC.new, 0.25)
		end

		should "the mutations should have been used according to their possibilities" do
			count_a, count_b, count_c = 0, 0, 0

			ITERATIONS.times do
				mutated = @combinded_mutation.mutate(@individual)
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