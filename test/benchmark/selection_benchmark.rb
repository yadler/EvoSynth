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


require 'benchmark'
#require 'profile'


require 'evosynth'
require 'test/util/test_helper'

POPULATION_SIZE = 1000
SELECTION_TIMES = 1000
SELECT_COUNT = 10

population = EvoSynth::Population.new
POPULATION_SIZE.times { |i| population.add(TestMaximizingIndividual.new(i)) }

puts "Running selection benchmark with #{SELECTION_TIMES} selections (population size=#{POPULATION_SIZE}, select count=#{SELECT_COUNT}):"
EvoSynth::Selections.constants.each do |selection|
	selection = EvoSynth::Selections.const_get(selection).new
#	selection = EvoSynth::Selections::NStageTournamentSelection.new

	timing = Benchmark.measure do
		SELECTION_TIMES.times { selection.select(population, SELECT_COUNT) }
	end
	puts "\t#{timing.format("%r")} - #{selection.class}"
end