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


class T_Test_Test < Test::Unit::TestCase

	context "when test with example in Weicker 2007, page 230" do

		setup do
			@alg1 = [3.7, 1.4, 5.2, 3.8, 4.4, 3.5, 2.9, 4.2, 6.5, 3.0]
			@alg2 = [4.2, 3.9, 4.7, 5.1, 4.1, 4.8, 3.8, 4.9, 4.0, 5.3]
		end

		should "t == -1.3258..." do
			assert_in_delta(-1.3258, EvoSynth::Benchmark.t_test(@alg1, @alg2), 0.00009)
		end

		should "Benchmark.expected_value(data) be correct" do
			assert_in_delta(3.86, EvoSynth::Benchmark.expected_value(@alg1), 0.001)
			assert_in_delta(4.48, EvoSynth::Benchmark.expected_value(@alg2), 0.001)
		end

		should "Benchmark.variance(data, expected_value) be correct" do
			assert_in_delta(1.8938, EvoSynth::Benchmark.variance(@alg1, EvoSynth::Benchmark.expected_value(@alg1)), 0.0009)
			assert_in_delta(0.2929, EvoSynth::Benchmark.variance(@alg2, EvoSynth::Benchmark.expected_value(@alg2)), 0.0009)
		end

	end

end