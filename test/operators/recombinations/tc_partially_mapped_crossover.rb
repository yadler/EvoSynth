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
require 'test/util/test_helper'

class PartiallyMappedCrossoverTest < Test::Unit::TestCase

	context "a partially mapped crossover run on example genome (Weicker page 133)" do

		setup do
			@recombination = EvoSynth::Recombinations::PartiallyMappedCrossover.new

			@individual_one = TestGenomeIndividual.new([1,4,6,5,7,2,3])
			@individual_two = TestGenomeIndividual.new([1,2,3,4,5,6,7])
		end

		context "before the partially mapped crossover is executed" do

			should "individual one should contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert_true @individual_one.genome.include? item }
			end

			should "individual two should contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert_true @individual_two.genome.include? item }
			end

		end

		context "after the partially mapped crossover is executed" do

			setup do
				@child_one, @child_two = @recombination.recombine(@individual_one, @individual_two)
			end

			should "parent one should (still) contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert_true @individual_one.genome.include? item }
			end

			should "parent two should (still) contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert_true @individual_two.genome.include? item }
			end

			should "both children should (still) contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert_true @child_one.genome.include? item }
				[1,2,3,4,5,6,7].each { |item| assert_true @child_two.genome.include? item }
			end

		end

	end

end