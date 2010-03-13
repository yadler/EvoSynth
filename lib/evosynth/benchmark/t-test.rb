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
	module Benchmark

		# hypothesis t-test, like in Weicker, page 230 or http://de.wikipedia.org/wiki/T-Test

		def Benchmark.t_test(data1, data2)
			raise ArgumentError.new("the two samples should have the same size for t-test!") if data1.size != data2.size

			exp_data1 = Benchmark.expected_value(data1)
			var_data1 = Benchmark.variance(data1, exp_data1)
			exp_data2 = Benchmark.expected_value(data2)
			var_data2 = Benchmark.variance(data2, exp_data2)
			(exp_data1 - exp_data2) / Math.sqrt((var_data1 + var_data2) / data1.size)
		end

		def Benchmark.expected_value(data)
			1.0 / data.size * data.inject(0.0) { |sum, x| sum += x }
		end

		def Benchmark.variance(data, expected_value)
			1.0 / (data.size - 1.0) * data.inject(0.0) { |sum, x| sum += (x - expected_value) ** 2.0 }
		end

	end
end