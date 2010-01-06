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


require 'evosynth'
require 'spec/test_helper_individual'

describe EvoSynth::Selections::StochasticUniversalSampling do

	it "it should select a super-individual" do
		pop = EvoSynth::Population.new
		pop.add(TestMinimizingIndividual.new(1))
		pop.add(TestMinimizingIndividual.new(2))
		pop.add(TestMinimizingIndividual.new(3))
		pop.add(TestMinimizingIndividual.new(4))
		pop.add(TestMinimizingIndividual.new(200))

		expected = EvoSynth::Population.new
		expected.add(TestMinimizingIndividual.new(200))
		expected.add(TestMinimizingIndividual.new(200))
		expected.add(TestMinimizingIndividual.new(200))

		fitness_proportional_selection = EvoSynth::Selections::FitnessProportionalSelection.new
		result = fitness_proportional_selection.select(pop, 3)
		result.should == expected
	end

end