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

describe EvoSynth::Selections::NStageTournamentSelection do

	# FIXME: this does actually fail sometimes

	it "it should select a super-individual" do
		pop = EvoSynth::Population.new
		individual1 = TestMinimizingIndividual.new(13)
		individual2 = TestMinimizingIndividual.new(12)
		individual3 = TestMinimizingIndividual.new(11)
		individual4 = TestMinimizingIndividual.new(10)
		super_individual = TestMinimizingIndividual.new(0)
		pop.add(individual1)
		pop.add(individual2)
		pop.add(individual3)
		pop.add(individual4)
		pop.add(super_individual)

		expected = EvoSynth::Population.new
		expected.add(super_individual)
		tournament_selection = EvoSynth::Selections::NStageTournamentSelection.new
		result = tournament_selection.select(pop)
		result.should == expected
	end

end