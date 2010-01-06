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