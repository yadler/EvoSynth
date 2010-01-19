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
	module BenchmarkFuntions

		# Sinus Sum function (Schwefel 1995)
		#
		# global minimum: f(x) = 0 at x(i) = 420.9687, i = 1..n

		def BenchmarkFuntions.sinus_sum(xs)
			418.98289 * xs.size + xs.inject(0.0) { |sum, x| sum += -x * (Math.sin Math.sqrt x.abs) }
		end

		# Double Sum function (Schwefel 1977)
		#
		# global minimum: f(x) = 0 at x(i) = 0, i = 1..n

		def BenchmarkFuntions.double_sum(xs)
			xs.inject(0.0) do |sum, i|
				sum += xs[0..i].inject(0.0) { |sum, x| sum += x }
			end
		end

		# Sphere function (Rechenberg 1973 and De Jong 1975)
		#
		# global minimum: f(x) = 0 at x(i) = 0, i = 1..n

		def BenchmarkFuntions.sphere(xs)
			xs.inject(0.0) { |sum, x| sum += x**2 }
		end

		# Rastgrin (Törn & Zilinskas 1989)
		#
		# global minimum: f(x) = 0 at x(i) = 0, i = 1..n

		def BenchmarkFuntions.rastgrin(xs)
			10 * xs.size + xs.inject(0.0) { |sum, x| sum += x**2 - 10 * Math.cos(2 * Math::PI * x) }
		end

		# Rosenbrock (De Jong 1975)
		#
		# global minimum: f(x) = 0 at x(i) = 1, i = 1..n

		def BenchmarkFuntions.rosenbrock(xs)
			(0..xs.size - 2).inject(0.0) do |sum, i|
				sum += 100 * (xs[i]**2 - xs[i+1])**2 + (1 - xs[i])**2
			end
		end

	end
end
