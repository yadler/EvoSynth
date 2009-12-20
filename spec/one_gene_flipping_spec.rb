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

describe "One Gene Flipping" do # EvoSynth::Mutations.one_gene_flipping

	describe "when run on binary genome (size=10)" do
		before do
			@individual = TestBinaryIndividual.new(10)
			@individual.genome.map! { |gene| true }
		end

		describe "before mutation is executed" do
			it "all genes should be true" do
				@individual.genome.each { |gene| gene.should be_true }
			end
		end

		describe "after mutation is executed" do
			before do
				@mutated = EvoSynth::Mutations.one_gene_flipping(@individual)
			end

			it "all genes of the parent should (still) be true" do
				@individual.genome.each { |gene| gene.should be_true }
			end

			it "one gene should be false" do
				count = 0
				@mutated.genome.each { |gene| count += 1 if !gene }
				count.should == 1
			end
		end
	end

	describe "when run on binary genome (size=1)" do
		before do
			@individual = TestBinaryIndividual.new(1)
			@individual.genome.map! { |gene| true }
		end

		describe "before mutation is executed" do
			it "the gene should be true" do
				@individual.genome[0].should be_true
			end
		end

		describe "after mutation is executed" do
			before do
				@mutated = EvoSynth::Mutations.one_gene_flipping(@individual)
			end

			it "the gene of the parent should (still) be true" do
				@individual.genome[0].should be_true
			end

			it "the mutated gene should be false" do
				@mutated.genome[0].should be_false
			end
		end

		describe "after mutation is executed two times" do
			before do
				@mutated = EvoSynth::Mutations.one_gene_flipping(@individual)
				@mutated = EvoSynth::Mutations.one_gene_flipping(@mutated)
			end

			it "the gene of the parent should (still) be true" do
				@individual.genome[0].should be_true
			end

			it "the mutated gene should be true" do
				@mutated.genome[0].should be_true
			end
		end
	end
end
