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
require 'gnuplot'

require 'evosynth'


class BenchmarkFunctionsTest < Test::Unit::TestCase
	
	RUNS = 50000
	DELTA = 0.05

	context "the EvoSynth.normal_rand function" do

		should "should be correct" do
			xs = {}
			RUNS.times do |i|
				result = EvoSynth.normal_rand
				rounded = (result * 100).round.to_f/100
				xs[rounded] = 0 unless xs.has_key?(rounded)
				xs[rounded] += 1
			end

			xs_sorted = xs.sort
			x, y = [],[]
			xs_sorted.each { |v| x << v[0]; y << v[1] * 100.0 / RUNS }

#			Gnuplot.open do |gp|
#				Gnuplot::Plot.new( gp ) do |plot|
#
#					plot.title  "Rastgrin function with Elistism GA"
#					plot.xrange "[-5:5]"
#					plot.ylabel "fitness"
#					plot.xlabel "generation"
#
#
#
#					plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
#						ds.with = "lines"
#						ds.title = "best individual"
#					end
#				end
#			end

			at_zero = ((xs[0.00] * 100.0 / RUNS) + (xs[0.01] * 100.0 / RUNS) + (xs[-0.01] * 100.0 / RUNS)) / 3
			assert_in_delta(0.4, at_zero, DELTA)
			at_minus_one = ((xs[-1.00] * 100.0 / RUNS) + (xs[-1.01] * 100.0 / RUNS) + (xs[-0.99] * 100.0 / RUNS)) / 3
			assert_in_delta(0.24, at_minus_one, DELTA)
			at_plus_one = ((xs[1.00] * 100.0 / RUNS) + (xs[1.01] * 100.0 / RUNS) + (xs[0.99] * 100.0 / RUNS)) / 3
			assert_in_delta(0.24, at_plus_one, DELTA)
			at_minus_two = ((xs[-2.00] * 100.0 / RUNS) + (xs[-2.01] * 100.0 / RUNS) + (xs[-1.99] * 100.0 / RUNS)) / 3
			assert_in_delta(0.054, at_minus_two, DELTA)
			at_plus_two = ((xs[2.00] * 100.0 / RUNS) + (xs[2.01] * 100.0 / RUNS) + (xs[1.99] * 100.0 / RUNS)) / 3
			assert_in_delta(0.054, at_plus_two, DELTA)
		end

			
	end

end
