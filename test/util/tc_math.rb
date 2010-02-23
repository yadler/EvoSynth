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


class BenchmarkFunctionsTest < Test::Unit::TestCase

	context "the probability_density_function function" do

		should "should be correct" do
			range_size = 100.0
			sigma = 1.0
			mu = 0.0
			runs = 10000

			range_start = EvoSynth::Util::EvoMath.probability_density_function(sigma, sigma, mu)
			range_end = EvoSynth::Util::EvoMath.probability_density_function(0.0, sigma, mu)
			first_range = (range_start..range_end) # => approx. 68,27%

			range_start = EvoSynth::Util::EvoMath.probability_density_function(sigma, 2.0*sigma, mu)
			range_end = EvoSynth::Util::EvoMath.probability_density_function(sigma, sigma, mu)
			second_range = (range_start..range_end) # => approx. 95,45 %

			range_start = EvoSynth::Util::EvoMath.probability_density_function(sigma, 3.0*sigma, mu)
			range_end = EvoSynth::Util::EvoMath.probability_density_function(sigma, 2.0*sigma, mu)
			third_range = (range_start..range_end) # => approx. 99,73 %

			puts first_range, second_range, third_range
			first_cnt, second_cnt, third_cnt = 0, 0, 0

			x, y = [], []
			runs.times do |i|
				rnd = EvoSynth.rand * range_size * sigma - range_size/2.0 * sigma
#				rnd = - 5.0 + 10.0 / runs * i
				result = EvoSynth::Util::EvoMath.probability_density_function(rnd, sigma, mu)
				x << rnd
				y << result

				first_cnt += 1 if first_range.include?(result)
				second_cnt += 1 if second_range.include?(result)
				third_cnt += 1 if third_range.include?(result)
			end

			puts first_cnt, second_cnt, third_cnt
		end


	end

end