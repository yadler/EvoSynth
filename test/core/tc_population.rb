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


class PopulationTest < Test::Unit::TestCase

	context "when initialized without args" do
		setup do
			@population = EvoSynth::Core::Population.new
		end

		should "be empty" do
			assert @population.empty?
		end

		should "have a size of 0" do
			assert_equal 0, @population.size
		end
	end

	context "when it contains maximizingIndividuals" do
		setup do
			@population = EvoSynth::Core::Population.new
			@min = TestMaximizingIndividual.new(1)
			@second = TestMaximizingIndividual.new(299)
			@third = TestMaximizingIndividual.new(298)
			@max = TestMaximizingIndividual.new(300)

			@population.add(@max)
			@population.add(@min)
			@population.add(@third)
			@population.add(@second)

			10.times { @population.add(TestMaximizingIndividual.new(rand(10) + 10)) }
		end

		should "#best(3) return 3 individuals ordered by fitness (DESC)" do
			expected = []
			expected << @max << @second << @third
			assert_equal expected, @population.best(3)
		end

		should "#best return maximum in population" do
			assert_equal @max, @population.best
		end

		should "#worst return minimum in population" do
			assert_equal @min, @population.worst
		end
	end

	context "when it contains minizingIndividuals" do
		setup do
			@population = EvoSynth::Core::Population.new
			@min = TestMinimizingIndividual.new(1)
			@second = TestMinimizingIndividual.new(2)
			@third = TestMinimizingIndividual.new(3)
			@max = TestMinimizingIndividual.new(300)

			@population.add(@min)
			@population.add(@second)
			@population.add(@third)
			@population.add(@max)

			10.times { @population.add(TestMinimizingIndividual.new(rand(10) + 10)) }
		end

		should "#best(3) return 3 individuals ordered by fitness (ASC)" do
			expected = []
			expected << @min << @second << @third
			assert_equal expected, @population.best(3)
		end

		should "#best returns minimum in population" do
			assert_equal @min, @population.best
		end

		should "#worst returns maximum in population" do
			assert_equal @max, @population.worst
		end
	end

	should "[]= and [] work" do
		population = EvoSynth::Core::Population.new(2) { 0 }
		population[0] = "foo"
		population[1] = "bar"
		assert_equal 2, population.size
		assert_equal "foo", population[0]
		assert_equal "bar", population[1]
	end

	should "provide a working map! implementation" do
		pop = EvoSynth::Core::Population.new
		pop.add(TestMinimizingIndividual.new(1))
		pop.map! { |i| i.fitness = 2; i}
		assert_equal 2, pop[0].fitness
	end

	should "provide a working remove implementation" do
		pop = EvoSynth::Core::Population.new
		inividual_one = TestMinimizingIndividual.new(1)
		inividual_two = TestMinimizingIndividual.new(2)
		pop.add(inividual_one)
		pop.add(inividual_two)
		assert_equal 2, pop.size
		assert_equal inividual_one, pop[0]
		assert_equal inividual_two, pop[1]

		pop.remove(inividual_one)
		assert_equal inividual_two, pop[0]
	end

	should "all individuals should be 0 when created with {0}" do
		population = EvoSynth::Core::Population.new(1) { 0 }
		population.each { |individual| assert_equal 0, individual }
	end

	should "it's size should be 100 when we want it to be 100" do
		population = EvoSynth::Core::Population.new(100)
		assert_equal 100, population.size
	end

	should "when initialized without block it should only contain nil" do
		population = EvoSynth::Core::Population.new(1)
		assert_nil population[0]
	end

end