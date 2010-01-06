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