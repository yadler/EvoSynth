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


class PredefinedAjustmentTest < Test::Unit::TestCase

	ALPHA = 0.9

	context "a predefined adjustment with alpha = #{ALPHA}" do
		setup do
			@adjustment = EvoSynth::Adjustments::PredifinedAdjustment.new(ALPHA)
		end

		should "multiply a value with #{ALPHA} when adjust is called" do
			sigma = 1
			assert_equal sigma * ALPHA,  @adjustment.adjust(sigma)
			sigma = 3
			assert_equal sigma * ALPHA,  @adjustment.adjust(sigma)
		end

		should "deep_clone returns a new deep copy" do
			my_clone = @adjustment.deep_clone
			assert_not_equal my_clone.object_id, @adjustment.object_id
			assert my_clone.kind_of?(EvoSynth::Adjustments::PredifinedAdjustment)
			my_clone.alpha = 0.8
			assert_not_equal my_clone.alpha, @adjustment.alpha
		end
		
	end

end