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

describe "Tournament selection" do # EvoSynth::Selections.tournament

	it "it should select a super-individual" do
		pop = EvoSynth::Population.new()
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

		expected = EvoSynth::Population.new()
		expected.add(super_individual)
		result = EvoSynth::Selections.tournament(pop)
		result.should == expected
	end

end