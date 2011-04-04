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
require_relative '../../../test/test_util/test_helper'


class UniformRealMutationTest < Test::Unit::TestCase

	VALUE = 4.0
	PROBABILITY = 1.0
	DELTA = 0.4

	context "when run on a float genome = #{VALUE}" do
		setup do
			@individual = TestArrayGenomeIndividual.new([VALUE]*5)
		end

		context "before mutation is executed" do
			should "each gene should equal #{VALUE}" do
				@individual.genome.each { |gene| assert_equal VALUE, gene }
			end
		end

		context "after mutation is executed (probability = #{PROBABILITY})" do
			setup do
				mutation = EvoSynth::Mutations::UniformRealMutation.new(PROBABILITY, DELTA)
				@mutated = mutation.mutate(@individual)
			end

			should "all genes of the parent should (still) equal #{VALUE}" do
				@individual.genome.each { |gene| assert_equal VALUE, gene }
			end

			should "all genes of the child be in the around +/- #{DELTA} of #{VALUE}" do
				@mutated.genome.each { |gene| assert_in_delta VALUE, gene, DELTA }
			end
		end
	end

	context "after mutation is instantiated with probabiliy=#{PROBABILITY} and step_size=#{DELTA}" do
		setup do
			@mutation = EvoSynth::Mutations::UniformRealMutation.new(PROBABILITY, DELTA)
		end

		should "deep_clone returns a deep copy" do
			my_clone = @mutation.deep_clone
			assert_not_equal my_clone.object_id, @mutation.object_id
			assert_equal my_clone.instance_variable_get(:@probability), PROBABILITY
			assert_equal my_clone.instance_variable_get(:@step_size), DELTA
			assert_kind_of EvoSynth::Mutations::UniformRealMutation, my_clone
		end
	end
end