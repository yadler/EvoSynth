#    Copyright (C) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
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


require 'evosynth'
require 'spec/test_helper_individual'

describe EvoSynth::Selections::SelectBest do

	it "with minimizing individuals it should select the two min individuals" do
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
		result.should == expected
	end

	it "with maximizing individuals it should select the two max individuals" do
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
		result.should == expected
	end
end