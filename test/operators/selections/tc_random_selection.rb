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


class SelectBestTest < Test::Unit::TestCase

	TIMES = 1000
	DELTA = 0.1

	context "when run on a population of minimizing individuals " do

		should "should select every individual as often as the others" do
			population = EvoSynth::Core::Population.new
			individual1 = TestMinimizingIndividual.new(1)
			individual2 = TestMinimizingIndividual.new(2)
			individual3 = TestMinimizingIndividual.new(3)
			population.add(individual1)
			population.add(individual2)
			population.add(individual3)

			count_one, count_two, count_three = 0, 0, 0

			TIMES.times do
				select_best = EvoSynth::Selections::RandomSelection.new
				result = select_best.select(population, 1)
				result.each do |individual|
					if individual == individual1
						count_one += 1
					elsif individual == individual2
						count_two += 1
					elsif individual == individual3
						count_three += 1
					end
				end
			end

			assert_in_delta TIMES/3.0, count_one, TIMES/3.0 * DELTA
			assert_in_delta TIMES/3.0, count_two, TIMES/3.0 * DELTA
			assert_in_delta TIMES/3.0, count_three, TIMES/3.0 * DELTA
		end

	end

end