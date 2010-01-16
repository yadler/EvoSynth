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
require 'test/test_util/test_helper'

module RecombinationBenchmark

	GENOME_SIZE = 1000
	RECOMBINATION_TIMES = 1000

	def RecombinationBenchmark.benchmark_recombination(recombination, individual_one, individual_two)
		timing = Benchmark.measure do
			RECOMBINATION_TIMES.times { recombination.recombine(individual_one, individual_two) }
		end
		puts "\t#{timing.format("%r")} - #{recombination.class}"
	end

	individual_one = TestArrayBinaryIndividual.new(GENOME_SIZE)
	individual_two = TestArrayBinaryIndividual.new(GENOME_SIZE)
	GENOME_SIZE.times { |index| individual_one.genome[index] = index }
	GENOME_SIZE.times { |index| individual_two.genome[index] = index }

	puts "Running recombination benchmark with #{RECOMBINATION_TIMES} recombinations (genome=#{GENOME_SIZE}):"
	EvoSynth::Recombinations.constants.each do |recombination|
		recombination = EvoSynth::Recombinations.const_get(recombination).new rescue next
		RecombinationBenchmark.benchmark_recombination(recombination, individual_one, individual_two)
	end

	interpolation = lambda { |gene_one, gene_two, factor| rand < factor ? gene_one : gene_two }
	recombination = EvoSynth::Recombinations::ArithmeticCrossover.new(interpolation)
	RecombinationBenchmark.benchmark_recombination(recombination, individual_one, individual_two)
end