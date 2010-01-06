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

# TODO: how could this be done in a good way?
# maybe I should do this in evosynth.rb?
# (see also max_ones.rb!)

class TrueClass
	def flip
		!self
	end
end

class FalseClass
	def flip
		!self
	end
end

describe EvoSynth::Mutations::OneGeneFlipping do

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
				one_gene_flipping = EvoSynth::Mutations::OneGeneFlipping.new
				@mutated = one_gene_flipping.mutate(@individual)
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
				one_gene_flipping = EvoSynth::Mutations::OneGeneFlipping.new
				@mutated = one_gene_flipping.mutate(@individual)
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
				one_gene_flipping = EvoSynth::Mutations::OneGeneFlipping.new
				@mutated = one_gene_flipping.mutate(@individual)
				@mutated = one_gene_flipping.mutate(@mutated)
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
