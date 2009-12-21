#    Copyright (C) 2009 Yves Adler <yves.adler@googlemail.com>
#
#    This file is part of EvoSynth, a framework for rapid prototyping of
#    evolutionary and genetic algorithms.
#
#    EvoSynth is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    EvoSynth is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with EvoSynth.  If not, see <http://www.gnu.org/licenses/>.

# Author::    Yves Adler (mailto:yves.adler@googlemail.com)
# Copyright:: Copyright (C) 2009 Yves Adler
# License::   LGPLv3

require 'evosynth'
require 'spec/test_helper_individual'

describe "Fitness proportional selection" do # EvoSynth::Selections.tournament

	it "it should select a super-individual" do
		pop = EvoSynth::Population.new()
		pop.add(TestMinimizingIndividual.new(1))
		pop.add(TestMinimizingIndividual.new(2))
		pop.add(TestMinimizingIndividual.new(3))
		pop.add(TestMinimizingIndividual.new(4))
		pop.add(TestMinimizingIndividual.new(200))

		expected = EvoSynth::Population.new()
		expected.add(TestMinimizingIndividual.new(200))

		# FIXME: find a real good test case

		fitness_proportional_selection = EvoSynth::Selections::FitnessProportionalSelection.new
		result = fitness_proportional_selection.select(pop, 1)
		result.should == expected
	end

end