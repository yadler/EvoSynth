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


module EvoSynth
	module Adjustments

		# ADAPTIVE-ANPASSUNG (Weicker page 113)

		class AdaptiveAdjustment
			attr_accessor :alpha, :theta

			DEFAULT_ALPHA = 1.2
			DEFAULT_THETA = 0.2
			DEFAULT_SUCCESS_RATE = 0.0

			def initialize(alpha = DEFAULT_ALPHA, theta = DEFAULT_THETA)
				@alpha = alpha
				@theta = theta
			end

			def adjust(sigma, success_rate = DEFAULT_SUCCESS_RATE)
				if success_rate > @theta
					sigma * @alpha
				elsif success_rate < @theta
					sigma / @alpha
				else
					sigma
				end
			end

		end

	end
end
