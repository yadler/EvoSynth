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

describe EvoSynth::Population do

	describe "when initialized without args" do
		before do
			@population = EvoSynth::Population.new
		end

		it "should be empty" do
			@population.should be_empty
		end

		it "should have a size of 0" do
			@population.size.should == 0
		end
	end

	describe "when it contains maximizingIndividuals" do
		before do
			@population = EvoSynth::Population.new
			@min = TestMaximizingIndividual.new(1)
			@second = TestMaximizingIndividual.new(299)
			@third = TestMaximizingIndividual.new(298)
			@max = TestMaximizingIndividual.new(300)

			@population.add(@min)
			@population.add(@second)
			@population.add(@third)
			@population.add(@max)

			10.times { @population.add(TestMaximizingIndividual.new(rand(10) + 10)) }
		end

		it "#best(3) returns 3 individuals ordered by fitness (DESC)" do
			expected = []
			expected << @max << @second << @third
			@population.best(3).should == expected
		end

		it "#best returns maximum in population" do
			@population.best.should == @max
		end

		it "#worst returns minimum in population" do
			@population.worst.should == @min
		end
	end

	describe "when it contains minizingIndividuals" do
		before do
			@population = EvoSynth::Population.new
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

		it "#best(3) returns 3 individuals ordered by fitness (ASC)" do
			expected = []
			expected << @min << @second << @third
			@population.best(3).should == expected
		end

		it "#best returns minimum in population" do
			@population.best.should == @min
		end

		it "#worst returns maximum in population" do
			@population.worst.should == @max
		end
	end

	it "[]= and [] should work" do
		population = EvoSynth::Population.new(2) { 0 }
		population[0] = "foo"
		population[1] = "bar"
		population.size.should == 2
		population[0].should == "foo"
		population[1].should == "bar"
	end

	it "should provide a working map! implementation" do
		pop = EvoSynth::Population.new
		pop.add(TestMinimizingIndividual.new(1))
		pop.map! { |i| i.fitness = 2; i}
		pop[0].fitness.should == 2
	end

	it "all individuals should be 0 when created with {0}" do
		population = EvoSynth::Population.new(1) { 0 }
		population.each { |individual| individual.should == 0 }
	end

	it "it's size should be 100 when we want it to be 100" do
		population = EvoSynth::Population.new(100)
		population.size == 100
	end

	it "when initialized without block it should only contain nil" do
		population = EvoSynth::Population.new(1)
		population[0].should be_nil
	end

end