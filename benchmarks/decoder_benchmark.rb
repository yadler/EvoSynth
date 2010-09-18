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
require './test/test_util/test_helper'

module DecoderBenchmark

	GENOME_SIZE = 1000
	BENCHMARK_TIMES = 10000

	individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
	GENOME_SIZE.times { |index| individual.genome[index] = (index % 2 == 1) ? true : false }

	puts "Running decoder benchmark (on ArrayGenome filled with BOOLEANS!) with #{BENCHMARK_TIMES} decodings (genome=#{GENOME_SIZE}):"
	timing = Benchmark.measure do
		BENCHMARK_TIMES.times { EvoSynth::Decoder.binary_to_gray(individual.genome) }
	end
	puts "\t#{timing.format("%r")} - EvoSynth::Decoder.binary_to_gray"

	timing = Benchmark.measure do
		BENCHMARK_TIMES.times { EvoSynth::Decoder.gray_to_binary(individual.genome) }
	end
	puts "\t#{timing.format("%r")} - EvoSynth::Decoder.gray_to_binary"

	timing = Benchmark.measure do
		BENCHMARK_TIMES.times { EvoSynth::Decoder.binary_to_real(individual.genome) }
	end
	puts "\t#{timing.format("%r")} - EvoSynth::Decoder.binary_to_real"

	individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
	GENOME_SIZE.times { |index| individual.genome[index] = (index % 2 == 1) ? 1 : 0 }

	puts "Running decoder benchmark (on ArrayGenome filled with INTEGERS!) with #{BENCHMARK_TIMES} decodings (genome=#{GENOME_SIZE}):"
	timing = Benchmark.measure do
		BENCHMARK_TIMES.times { EvoSynth::Decoder.binary_to_gray(individual.genome) }
	end
	puts "\t#{timing.format("%r")} - EvoSynth::Decoder.binary_to_gray"

	timing = Benchmark.measure do
		BENCHMARK_TIMES.times { EvoSynth::Decoder.gray_to_binary(individual.genome) }
	end
	puts "\t#{timing.format("%r")} - EvoSynth::Decoder.gray_to_binary"

	timing = Benchmark.measure do
		BENCHMARK_TIMES.times { EvoSynth::Decoder.binary_to_real(individual.genome) }
	end
	puts "\t#{timing.format("%r")} - EvoSynth::Decoder.binary_to_real"

end