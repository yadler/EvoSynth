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


class ConditionalCombinedOperatorTest < Test::Unit::TestCase

	GENOME_SIZE = 20
	ITERATIONS = 1000
	DELTA = 0.05

	context "when run on binary genome (size=#{GENOME_SIZE}) without a mutation" do
		setup do
			@individual = "Start"
			@operator = EvoSynth::MetaOperators::ConditionalCombinedOperator.new
		end

		should "raise a exception" do
			assert_raise(RuntimeError) { @operator.mutate(@individual) }
		end
	end

	context "when run on binary genome with probabilties both should be called as often as they should ;)" do
		setup do
			@foo = 0
			@individual = "I "
			@mutation_a = TestMutationA.new
			@mutation_b = TestMutationB.new
			@combinded_operator = EvoSynth::MetaOperators::ConditionalCombinedOperator.new
			@combinded_operator.add(@mutation_a) { @foo > ITERATIONS/2 }
			@combinded_operator.add(@mutation_b) { @foo < ITERATIONS/2 }
		end

		should "both mutations should have been used #{ITERATIONS} times" do
			ITERATIONS.times { @foo +=1; @combinded_operator.mutate(@individual) }

			assert_in_delta ITERATIONS/2, @mutation_a.called, DELTA * ITERATIONS
			assert_in_delta ITERATIONS/2, @mutation_b.called, DELTA * ITERATIONS
		end

		should "deep_clone returns a new deep copy" do
			my_clone = @combinded_operator.deep_clone
			assert_not_equal my_clone.object_id, @combinded_operator.object_id
			assert_not_equal my_clone.instance_variable_get(:@operators).object_id,
											@combinded_operator.instance_variable_get(:@operators).object_id

			my_clone.instance_variable_get(:@operators).each_index do |index|
				assert_not_equal my_clone.instance_variable_get(:@operators)[index][0].object_id,
											@combinded_operator.instance_variable_get(:@operators)[index][0].object_id
				assert_not_equal my_clone.instance_variable_get(:@operators)[index][1].object_id,
											@combinded_operator.instance_variable_get(:@operators)[index][1].object_id
			end
			assert_kind_of TestMutationA, my_clone.instance_variable_get(:@operators)[0][0]
			assert_kind_of TestMutationB, my_clone.instance_variable_get(:@operators)[1][0]
		end
	end
end