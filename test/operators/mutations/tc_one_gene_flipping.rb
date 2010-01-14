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


require 'shoulda'

require 'evosynth'
require 'test/test_util/test_helper'


class OneGeneFlippingTest < Test::Unit::TestCase

	GENOME_SIZE = 20
	FLIP_FUNCTION = EvoSynth::Mutations::Functions::FLIP_BOOLEAN

	context "when run on binary genome (size=#{GENOME_SIZE})" do
		setup do
			@individual = TestBinaryIndividual.new(GENOME_SIZE)
			@individual.genome.map! { |gene| true }
		end

		context "before mutation is executed" do
			should "all genes should be true" do
				@individual.genome.each { |gene| assert gene }
			end
		end

		context "after mutation is executed" do
			setup do
				one_gene_flipping = EvoSynth::Mutations::OneGeneFlipping.new(FLIP_FUNCTION)
				@mutated = one_gene_flipping.mutate(@individual)
			end

			should "all genes of the parent should (still) be true" do
				@individual.genome.each { |gene| assert gene }
			end

			should "one gene should be false" do
				count = 0
				@mutated.genome.each { |gene| count += 1 if !gene }
				assert_equal 1, count
			end
		end
	end

	context "when run on binary genome (size=1)" do
		setup do
			@individual = TestBinaryIndividual.new(1)
			@individual.genome.map! { |gene| true }
		end

		context "before mutation is executed" do
			should "the gene should be true" do
				assert @individual.genome[0]
			end
		end

		context "after mutation is executed" do
			setup do
				one_gene_flipping = EvoSynth::Mutations::OneGeneFlipping.new(FLIP_FUNCTION)
				@mutated = one_gene_flipping.mutate(@individual)
			end

			should "the gene of the parent should (still) be true" do
				assert @individual.genome[0]
			end

			should "the mutated gene should be false" do
				assert !@mutated.genome[0]
			end
		end

		context "after mutation is executed two times" do
			setup do
				one_gene_flipping = EvoSynth::Mutations::OneGeneFlipping.new(FLIP_FUNCTION)
				@mutated = one_gene_flipping.mutate(@individual)
				@mutated = one_gene_flipping.mutate(@mutated)
			end

			should "the gene of the parent should (still) be true" do
				assert @individual.genome[0]
			end

			should "the mutated gene should be true" do
				assert @mutated.genome[0]
			end
		end
	end
end