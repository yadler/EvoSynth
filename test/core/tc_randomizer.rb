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
#require 'gnuplot'

require 'evosynth'


class BenchmarkFunctionsTest < Test::Unit::TestCase
	
	RUNS = 50000
	DELTA = 0.05

	def assert_point(xs, value, expected, point, scale)
		offset = point * scale
		v1 = xs[value+(offset)].nil? ? 0 : xs[value+(offset)]
		v2 = xs[value+(offset+0.01)].nil? ? 0 : xs[value+(offset+0.01)]
		v3 = xs[value+(offset-0.01)].nil? ? 0 : xs[value+(offset-0.01)]
		at_point = ((v1 * 100.0 / RUNS) + (v2 * 100.0 / RUNS) + (v3 * 100.0 / RUNS)) / 3
		assert_in_delta(expected/scale, at_point, DELTA)
	end

	def assert_result(xs, value = 0.0, scale = 1.0)
		assert_point(xs, value, 0.4, 0.0, scale)
		assert_point(xs, value, 0.24, -1.0, scale)
		assert_point(xs, value, 0.24, 1.0, scale)
		assert_point(xs, value, 0.054, 2.0, scale)
		assert_point(xs, value, 0.054, -2.0, scale)
	end

	context "the EvoSynth.normal_rand function" do

		should "should be correct with default values" do
			xs = {}
			RUNS.times do |i|
				result = EvoSynth.nrand
				rounded = (result * 100).round.to_f/100
				xs[rounded] = 0 unless xs.has_key?(rounded)
				xs[rounded] += 1
			end
			assert_result(xs, 0.0, 1.0)

			xs_sorted = xs.sort
			x, y = [],[]
			xs_sorted.each { |v| x << v[0]; y << v[1] * 100.0 / RUNS }

#			Gnuplot.open do |gp|
#				Gnuplot::Plot.new( gp ) do |plot|
#
#					plot.title  "normal distributed random numbers"
#					plot.xrange "[-5:5]"
#
#					plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
#						ds.with = "lines"
#					end
#				end
#			end
		end


		should "should be correct with mu = 2.0 values" do
			xs = {}
			RUNS.times do |i|
				result = EvoSynth.nrand(2.0)
				rounded = (result * 100).round.to_f/100
				xs[rounded] = 0 unless xs.has_key?(rounded)
				xs[rounded] += 1
			end
			assert_result(xs, 2.0, 1.0)

			xs_sorted = xs.sort
			x, y = [],[]
			xs_sorted.each { |v| x << v[0]; y << v[1] * 100.0 / RUNS }

#			Gnuplot.open do |gp|
#				Gnuplot::Plot.new( gp ) do |plot|
#
#					plot.title  "normal distributed random numbers"
#					plot.xrange "[-5:5]"
#
#					plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
#						ds.with = "lines"
#					end
#				end
#			end
		end

		should "should be correct with mu = -13.0 values" do
			xs = {}
			RUNS.times do |i|
				result = EvoSynth.nrand(-13.0)
				rounded = (result * 100).round.to_f/100
				xs[rounded] = 0 unless xs.has_key?(rounded)
				xs[rounded] += 1
			end
			assert_result(xs, -13.0, 1.0)

			xs_sorted = xs.sort
			x, y = [],[]
			xs_sorted.each { |v| x << v[0]; y << v[1] * 100.0 / RUNS }

#			Gnuplot.open do |gp|
#				Gnuplot::Plot.new( gp ) do |plot|
#
#					plot.title  "normal distributed random numbers"
#					plot.xrange "[-5:5]"
#
#					plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
#						ds.with = "lines"
#					end
#				end
#			end
		end

		should "should be correct with mu = -13.0 and sigma = 2.0values" do
			xs = {}
			RUNS.times do |i|
				result = EvoSynth.nrand(0.0, 2.0)
				rounded = (result * 100).round.to_f/100
				xs[rounded] = 0 unless xs.has_key?(rounded)
				xs[rounded] += 1
			end
#			assert_result(xs, -13.0, 2.0)

			xs_sorted = xs.sort
			x, y = [],[]
			xs_sorted.each { |v| x << v[0]; y << v[1] * 100.0 / RUNS }

#			Gnuplot.open do |gp|
#				Gnuplot::Plot.new( gp ) do |plot|
#
#					plot.title  "normal distributed random numbers"
#					plot.xrange "[-5:5]"
#
#					plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
#						ds.with = "lines"
#					end
#				end
#			end
		end
	end

end
