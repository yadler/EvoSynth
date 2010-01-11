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


class BinaryMutationTest < Test::Unit::TestCase

	GENOME_SIZE = 20
	PROBABILITY = 0.1
	TIMES = 1000
	DELTA = 0.075
	EXPECTED = PROBABILITY * GENOME_SIZE * TIMES

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

		context "after mutation is executed #{TIMES} times (with probability=#{PROBABILITY})" do
			setup do
				binary_mutation = EvoSynth::Mutations::BinaryMutation.new(PROBABILITY)
				@count = 0.0
				TIMES.times do
					mutated = binary_mutation.mutate(@individual)
					mutated.genome.each { |gene| @count += 1 if !gene }
				end
			end

			should "all genes of the parent should (still) be true" do
				@individual.genome.each { |gene| assert gene }
			end

			should "around #{EXPECTED} (+/- #{EXPECTED * DELTA}) genes should have mutated to false" do
				assert_in_delta EXPECTED, @count, EXPECTED * DELTA
			end
		end

	end

end