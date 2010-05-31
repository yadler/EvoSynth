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
	module Problems

		# This module contains some multi-dimensional Benchmarkfunctions. You simply set the number of dimensions by
		# the length of the given (boolean) array.

		module BinaryBenchmarkFuntions

			# count-ones function
			#
			# global maximum at f(x) = x at x(i) = 1 (or true), i = 1..n

			def BinaryBenchmarkFuntions.count_ones(bs)
				bs.inject(0) { |sum, b| sum += (b == true || b == 1 ? 1 : 0) }
			end

			# Royal-Road function (Mitchell et al 1992)
			#
			# global minimum: f(x) = 0 at x(i) = 1, i = 1..n (bs.size % k == 0)

			def BinaryBenchmarkFuntions.royal_road(k, bs)
				m = bs.size / k
				sum = 0

				m.times do |i|
					sum += bs[(i*k)..(i+1)*k-1].inject(1) { |res, b| res = (b != 1 ? 0 : res) }
				end

				sum
			end

			# N-Peak problem presented in "Using Problem Generators to Explore the Effects of Epistasis", De Jong et al 1997
			#
			# global maximum: f(x) = 1.0 when peak == xs (hamming distance is 0)

			def BinaryBenchmarkFuntions.n_peaks(peaks, xs)
				max_hamming_dist = xs.size

				peaks.each do |peak|
					new_dist = 0.0
					xs.each_with_index { |x, index| new_dist += 1 if x != peak[index] }
					max_hamming_dist = new_dist if new_dist < max_hamming_dist
				end

				1.0 / xs.size * (xs.size - max_hamming_dist)
			end

			# SP_k problem
			#
			# TODO: needs rdoc and testcase

			def BinaryBenchmarkFuntions.sp_k(k, bs)
				length_of_ones = bs.take_while { |i| i == true }.length

				below_max_k = length_of_ones / k <= (bs.size / (3.0 * k**2)).ceil
				divisible = length_of_ones % k == 0
				valid_order = length_of_ones == bs.count(true)

				if valid_order && below_max_k && divisible
					bs.size * (bs.count(true) + 1)
				else
					bs.size - bs.count(true)
				end
			end

		end
	end
end
