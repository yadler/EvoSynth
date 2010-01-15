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


class NStageTournamentSelectionTest < Test::Unit::TestCase

	INDIVIDUALS = 100
	SELECT_N_TIMES = 100
	MAX_VALUE = 1000000

	context "when run on a population of minimizing individuals " do

		should "select a super-individual" do
			fitness_proportional_selection = EvoSynth::Selections::NStageTournamentSelection.new
			population = EvoSynth::Core::Population.new
			expected = EvoSynth::Core::Population.new

			(INDIVIDUALS - 1).times { population.add(TestMinimizingIndividual.new(MAX_VALUE)) }
			population.add(TestMinimizingIndividual.new(1))

			expected.add(TestMinimizingIndividual.new(1))

			SELECT_N_TIMES.times do
				result = fitness_proportional_selection.select(population, 1)
				assert_equal expected, result
			end
		end

	end

	context "when run on a population of maximizing individuals " do

		should "select a super-individual" do
			fitness_proportional_selection = EvoSynth::Selections::NStageTournamentSelection.new
			population = EvoSynth::Core::Population.new
			expected = EvoSynth::Core::Population.new

			(INDIVIDUALS - 1).times { population.add(TestMaximizingIndividual.new(1)) }
			population.add(TestMaximizingIndividual.new(MAX_VALUE))

			expected.add(TestMaximizingIndividual.new(MAX_VALUE))

			SELECT_N_TIMES.times do
				result = fitness_proportional_selection.select(population, 1)
				assert_equal expected, result
			end
		end

	end


end