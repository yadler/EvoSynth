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


class SelectBestTest < Test::Unit::TestCase

	context "when run on a population of minimizing individuals " do

		should "select the two individuals with the lowest fitness values" do
			population = EvoSynth::Population.new
			individual1 = TestMinimizingIndividual.new(1)
			individual2 = TestMinimizingIndividual.new(2)
			individual3 = TestMinimizingIndividual.new(3)
			individual4 = TestMinimizingIndividual.new(5)
			individual5 = TestMinimizingIndividual.new(20)
			population.add(individual1)
			population.add(individual2)
			population.add(individual3)
			population.add(individual4)
			population.add(individual5)

			expected = EvoSynth::Population.new
			expected.add(individual1)
			expected.add(individual2)

			select_best = EvoSynth::Selections::SelectBest.new
			result = select_best.select(population, 2)
			assert_equal expected, result
		end

	end

	context "when run on a population of maximizing individuals " do

		should "select the two individuals with the highest fitness values" do
			population = EvoSynth::Population.new
			individual1 = TestMaximizingIndividual.new(1)
			individual2 = TestMaximizingIndividual.new(2)
			individual3 = TestMaximizingIndividual.new(3)
			individual4 = TestMaximizingIndividual.new(5)
			individual5 = TestMaximizingIndividual.new(20)
			population.add(individual1)
			population.add(individual2)
			population.add(individual3)
			population.add(individual4)
			population.add(individual5)

			expected = EvoSynth::Population.new
			expected.add(individual5)
			expected.add(individual4)

			select_best = EvoSynth::Selections::SelectBest.new
			result = select_best.select(population, 2)
			assert_equal expected, result
		end

	end

end