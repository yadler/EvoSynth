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
require './test/test_util/test_helper'


class AdaptiveAjustmentTest < Test::Unit::TestCase

	ALPHA = 0.9
	THETA = 0.2

	context "a adaptive adjustment with alpha = #{ALPHA}, theta = #{THETA}" do
		setup do
			@adjustment = EvoSynth::Adjustments::AdaptiveAdjustment.new(ALPHA, THETA)
		end

		should "divide a value with #{ALPHA} when adjust is called without success_rate" do
			sigma = 1
			assert_equal sigma / ALPHA,  @adjustment.adjust(sigma)
			sigma = 3
			assert_equal sigma / ALPHA,  @adjustment.adjust(sigma)
		end

		should "divide a value with #{ALPHA} when adjust is called with a success_rate > #{THETA}" do
			sigma = 1
			assert_equal sigma * ALPHA,  @adjustment.adjust(sigma, THETA*2)
			sigma = 3
			assert_equal sigma * ALPHA,  @adjustment.adjust(sigma, THETA*2)
		end

		should "return the given value when success_rate == #{THETA}" do
			sigma = 1
			assert_equal sigma,  @adjustment.adjust(sigma, THETA)
			sigma = 3
			assert_equal sigma,  @adjustment.adjust(sigma, THETA)
		end
	end

end