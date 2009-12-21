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

describe EvoSynth::Recombinations::UniformCrossover do

	describe "when run on binary genome (size=100)" do
		before do
			@individual_one = TestBinaryIndividual.new(100)
			@individual_one.genome.map! { |gene| true }
			@individual_two = TestBinaryIndividual.new(100)
			@individual_two.genome.map! { |gene| false }
		end

		describe "before recombination is executed" do
			it "all genes of individual one should be true" do
				@individual_one.genome.each { |gene| gene.should be_true }
			end

			it "all genes of individual two should be false" do
				@individual_two.genome.each { |gene| gene.should be_false }
			end
		end

		describe "after recombination is executed 100 times" do
			before do
				uniform_crossover = EvoSynth::Recombinations::UniformCrossover.new
				@count = [0, 0]
				100.times do
					recombined = uniform_crossover.recombine(@individual_one, @individual_two)
					recombined[0].genome.each { |gene| @count[0] += 1 if !gene }
					recombined[1].genome.each { |gene| @count[1] += 1 if !gene }
				end
			end

			it "all genes of the parent one should (still) be true" do
				@individual_one.genome.each { |gene| gene.should be_true }
			end

			it "all genes of the parent two should (still) be false" do
				@individual_two.genome.each { |gene| gene.should be_false }
			end

			it "around 50 genes should have mutated to false (in both children)" do
				@count[0].should be_close(5000, 60)
				@count[1].should be_close(5000, 60)
			end
		end

	end

end
