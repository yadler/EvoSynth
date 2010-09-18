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
require './test/test_util/test_helper'


class GaussMutationTest < Test::Unit::TestCase

	RUNS = 10000
	DELTA = 0.2 # TODO: try to lower it to 0.08 => why the heck is 1.0 and -1.0 not as correct as the other values? test with delta == 0.05!
	VALUE = 8.0
	MAX_DELTA = 3.5

	context "when run on a float genome = #{VALUE}" do
		setup do
			@individual = TestArrayGenomeIndividual.new([VALUE]*5)
		end

		context "before mutation is executed" do
			should "each gene should equal #{VALUE}" do
				@individual.genome.each { |gene| assert_equal VALUE, gene }
			end
		end

		context "after mutation is executed" do
			setup do
				mutation = EvoSynth::Mutations::GaussMutation.new
				@mutated = mutation.mutate(@individual)
			end

			should "all genes of the parent should (still) equal #{VALUE}" do
				@individual.genome.each { |gene| assert_equal VALUE, gene }
			end

			should "all genes of the child be in the around +/- #{MAX_DELTA} of #{VALUE}" do
				@mutated.genome.each { |gene| assert_in_delta VALUE, gene, MAX_DELTA }
			end

		end

		context "when executed #{RUNS} times" do
			16.times do |i|
				value = VALUE - i.to_f
				
				should "should be normally distributed around #{value}" do
#					puts "testing with #{value}"

					mutation = EvoSynth::Mutations::GaussMutation.new
					individual = TestArrayGenomeIndividual.new([value])

					xs = {}

					RUNS.times do |i|
						mutated = mutation.mutate(individual)
						rounded = (mutated.genome[0] * 100).round.to_f/100
						xs[rounded] = 0 unless xs.has_key?(rounded)
						xs[rounded] += 1
					end

					xs_sorted = xs.sort
					x, y = [],[]
					xs_sorted.each { |v| x << v[0]; y << v[1] * 100.0 / RUNS }

#					require 'gnuplot'
#					Gnuplot.open do |gp|
#						Gnuplot::Plot.new( gp ) do |plot|
#
#							plot.title  "gauss mutation results"
#							plot.xrange "[-10:10]"
#
#							plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
#								ds.with = "dots"
#							end
#						end
#					end
					at_zero = ((xs[value] * 100.0 / RUNS) + (xs[value+0.01] * 100.0 / RUNS) + (xs[value-0.01] * 100.0 / RUNS)) / 3
					assert_in_delta(0.4, at_zero, DELTA)

					v1 = xs[value-1.00].nil? ? 0 : xs[value-1.00]
					v2 = xs[value-1.01].nil? ? 0 : xs[value-1.01]
					v3 = xs[value-0.99].nil? ? 0 : xs[value-0.99]
					at_minus_one = ((v1 + v2 + v3) * 100.0 / RUNS) / 3
					assert_in_delta(0.24, at_minus_one, DELTA)

					v1 = xs[value+1.00].nil? ? 0 : xs[value+1.00]
					v2 = xs[value+1.01].nil? ? 0 : xs[value+1.01]
					v3 = xs[value+0.99].nil? ? 0 : xs[value+0.99]
					at_plus_one = ((v1 * 100.0 / RUNS) + (v2 * 100.0 / RUNS) + (v3 * 100.0 / RUNS)) / 3
					assert_in_delta(0.24, at_plus_one, DELTA)

					v1 = xs[value-2.00].nil? ? 0 : xs[value-2.00]
					v2 = xs[value-2.01].nil? ? 0 : xs[value-2.01]
					v3 = xs[value-1.99].nil? ? 0 : xs[value-1.99]
					at_minus_two = ((v1 * 100.0 / RUNS) + (v2 * 100.0 / RUNS) + (v3 * 100.0 / RUNS)) / 3
					assert_in_delta(0.054, at_minus_two, DELTA)

					v1 = xs[value+2.00].nil? ? 0 : xs[value+2.00]
					v2 = xs[value+2.01].nil? ? 0 : xs[value+2.01]
					v3 = xs[value+1.99].nil? ? 0 : xs[value+1.99]
					at_plus_two = ((v1 * 100.0 / RUNS) + (v2 * 100.0 / RUNS) + (v3 * 100.0 / RUNS)) / 3
					assert_in_delta(0.054, at_plus_two, DELTA)
				end
			end
		end
	end
end