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

# FIXME: add some meaningful test here

class SelfadaptiveGaussMutationTest < Test::Unit::TestCase

	VALUE = 4.0
	DELTA = 0.1

	context "when run on a float genome = #{VALUE}" do
		setup do
			@individual = TestArrayGenomeIndividual.new([VALUE]*5)
		end

		context "before mutation is executed" do
			should "each gene should equal #{VALUE}" do
				@individual.genome.each { |gene| assert_equal VALUE, gene }
			end

			should "the individual have no sigma method" do
				assert_raise(NoMethodError) { @individual.sigma }
			end
		end

		context "after mutation is executed" do
			setup do
				mutation = EvoSynth::Mutations::SelfAdaptiveGaussMutation.new
				@mutated = mutation.mutate(@individual)
			end

			should "all genes of the parent should (still) equal #{VALUE}" do
				@individual.genome.each { |gene| assert_equal VALUE, gene }
			end

			should "the individual have a sigma method" do
				assert_respond_to @mutated, :sigma
			end

			should "the individual have a sigma that around 1.0 += 2.5" do
				assert_in_delta 1.0, @mutated.sigma, 2.5
			end
		end
	end

	context "after mutation is instantiated" do
		setup do
			@mutation =  EvoSynth::Mutations::SelfAdaptiveGaussMutation.new
		end

		should "deep_clone returns a deep copy" do
			my_clone = @mutation.deep_clone
			assert_not_equal my_clone.object_id, @mutation.object_id
			assert_equal my_clone.initial_sigma, @mutation.initial_sigma
			assert_equal my_clone.lower_bound, @mutation.lower_bound
			assert_equal my_clone.upper_bound, @mutation.upper_bound
			assert_kind_of EvoSynth::Mutations::SelfAdaptiveGaussMutation, my_clone
		end
	end
end