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


class SchwefelTest < Test::Unit::TestCase

	should "be near zero at [420.9687463, 420.9687463, 420.9687463]" do
		xs = [420.9687463, 420.9687463, 420.9687463]
		assert_in_delta 0, EvoSynth::BenchmarkFuntions.schwefel(xs), 0.0001
	end

	should "be near 48.452841639435974 at [422.400, 418.840, 406.880, 421.700, 424.780, 412.740, 419.800, 416.000, 413.040, 417.620]" do
		xs = [422.400, 418.840, 406.880, 421.700, 424.780, 412.740, 419.800, 416.000, 413.040, 417.620]
		assert_in_delta 48.452841639435974, EvoSynth::BenchmarkFuntions.schwefel(xs), 0.0001
	end

end
