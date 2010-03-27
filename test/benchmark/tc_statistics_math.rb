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


class StatisticsMathTest < Test::Unit::TestCase

	context "the mean of a array" do
		setup do
			@array = [0,1,1,1,0,0]
		end

		should "be 0.5" do
			assert_equal(0.5, EvoSynth::EvoBench.mean(@array))
		end
	end

	context "the mean of a population" do
		setup do
			@population = EvoSynth::Population.new
			@population.add(TestMaximizingIndividual.new(1))
			@population.add(TestMaximizingIndividual.new(0))
			@population.add(TestMaximizingIndividual.new(0))
			@population.add(TestMaximizingIndividual.new(1))
			@population.add(TestMaximizingIndividual.new(1))
			@population.add(TestMaximizingIndividual.new(0))
		end

		should "be 0.5" do
			assert_equal(0.5, EvoSynth::EvoBench.mean(@population) { |individual| individual.fitness } )
			assert_equal(0.5, EvoSynth::EvoBench.population_fitness_mean(@population))
		end
	end

	context "the median of a even array" do
		setup do
			@array = [1,2,3,4,5,6]
		end

		should "be 3.5" do
			assert_equal(3.5, EvoSynth::EvoBench.median(@array))
		end
	end

	context "the median of a uneven array" do
		setup do
			@array = [1,2,3,4,5,6,7]
		end

		should "be 4" do
			assert_equal(4, EvoSynth::EvoBench.median(@array))
		end
	end

	context "the median of a even population" do
		setup do
			@population = EvoSynth::Population.new
			@population.add(TestMaximizingIndividual.new(1))
			@population.add(TestMaximizingIndividual.new(2))
			@population.add(TestMaximizingIndividual.new(3))
			@population.add(TestMaximizingIndividual.new(4))
			@population.add(TestMaximizingIndividual.new(5))
			@population.add(TestMaximizingIndividual.new(6))
		end

		should "be 3.5" do
			assert_equal(3.5, EvoSynth::EvoBench.median(@population) { |individual| individual.fitness })
			assert_equal(3.5, EvoSynth::EvoBench.population_fitness_median(@population))
		end
	end

	context "the median of a uneven population" do
		setup do
			@population = EvoSynth::Population.new
			@population.add(TestMaximizingIndividual.new(4))
			@population.add(TestMaximizingIndividual.new(5))
			@population.add(TestMaximizingIndividual.new(1))
			@population.add(TestMaximizingIndividual.new(7))
			@population.add(TestMaximizingIndividual.new(2))
			@population.add(TestMaximizingIndividual.new(3))
			@population.add(TestMaximizingIndividual.new(6))
		end

		should "be 4" do
			assert_equal(4, EvoSynth::EvoBench.median(@population) { |individual| individual.fitness })
			assert_equal(4, EvoSynth::EvoBench.population_fitness_median(@population))
		end
	end

	context "the variance of two arrays" do
		setup do
			@alg1 = [3.7, 1.4, 5.2, 3.8, 4.4, 3.5, 2.9, 4.2, 6.5, 3.0]
			@alg2 = [4.2, 3.9, 4.7, 5.1, 4.1, 4.8, 3.8, 4.9, 4.0, 5.3]
		end

		should "be 1.8938 and 0.2929" do
			assert_in_delta(1.8938, EvoSynth::EvoBench.variance(@alg1, EvoSynth::EvoBench.mean(@alg1)), 0.0009)
			assert_in_delta(0.2929, EvoSynth::EvoBench.variance(@alg2, EvoSynth::EvoBench.mean(@alg2)), 0.0009)
		end
	end

	context "the variance of a population" do
		setup do
			@alg1 = [3.7, 1.4, 5.2, 3.8, 4.4, 3.5, 2.9, 4.2, 6.5, 3.0]
			@population = EvoSynth::Population.new
			@population.add(TestMaximizingIndividual.new(3.7))
			@population.add(TestMaximizingIndividual.new(1.4))
			@population.add(TestMaximizingIndividual.new(5.2))
			@population.add(TestMaximizingIndividual.new(3.8))
			@population.add(TestMaximizingIndividual.new(4.4))
			@population.add(TestMaximizingIndividual.new(3.5))
			@population.add(TestMaximizingIndividual.new(2.9))
			@population.add(TestMaximizingIndividual.new(4.2))
			@population.add(TestMaximizingIndividual.new(6.5))
			@population.add(TestMaximizingIndividual.new(3.0))
		end

		should "be 1.8938 and 0.2929" do
			mean = EvoSynth::EvoBench.population_fitness_mean(@population)
			assert_in_delta(1.8938, EvoSynth::EvoBench.variance(@population, mean) { |individual| individual.fitness }, 0.0009)
		end
	end

end