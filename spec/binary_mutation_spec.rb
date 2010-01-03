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

describe EvoSynth::Mutations::BinaryMutation do

	describe "when run on binary genome (size=100)" do
		before do
			@individual = TestBinaryIndividual.new(100)
			@individual.genome.map! { |gene| true }
		end

		describe "before mutation is executed" do
			it "all genes should be true" do
				@individual.genome.each { |gene| gene.should be_true }
			end
		end

		describe "after mutations is executed 100 times (with probability 0.1)" do
			before do
				binary_mutation = EvoSynth::Mutations::BinaryMutation.new(0.1)
				@count = 0.0
				100.times do
					mutated = binary_mutation.mutate(@individual)
					mutated.genome.each { |gene| @count += 1 if !gene }
				end
			end

			it "all genes of the parent should (still) be true" do
				@individual.genome.each { |gene| gene.should be_true }
			end

			it "around 1000 (+/- 75)genes should have mutated to false" do
				@count.should be_close(1000, 75)
			end
		end

	end

end