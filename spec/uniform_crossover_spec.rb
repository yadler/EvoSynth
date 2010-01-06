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
