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

module MutationBenchmark

	GENOME_SIZE = 1000
	MUTATE_TIMES = 1000

	def MutationBenchmark.benchmark_mutation(mutation, individual)
		timing = Benchmark.measure do
			MUTATE_TIMES.times { mutation.mutate(individual) }
		end
		puts "\t#{timing.format("%r")} - #{mutation.class}"
	end

	def MutationBenchmark.run_benchmark(individual, flip_function)
		EvoSynth::Mutations.constants.each do |mutation|
			mutation_class = EvoSynth::Mutations.const_get(mutation)
			next if mutation_class == EvoSynth::Mutations::GaussMutation
			next if mutation_class == EvoSynth::Mutations::SelfAdaptiveGaussMutation
			next if mutation_class == EvoSynth::Mutations::UniformRealMutation

			begin
				mutation = mutation_class.new
			rescue
				mutation = mutation_class.new(flip_function) rescue next
			end

			MutationBenchmark.benchmark_mutation(mutation, individual)
		end
	end

	individual = TestArrayBinaryIndividual.new(GENOME_SIZE)
	GENOME_SIZE.times { |index| individual.genome[index] = (index % 2 == 1) ? true : false }

	puts "Running mutation benchmark (on ArrayGenome) with #{MUTATE_TIMES} mutations (genome=#{GENOME_SIZE}):"
	MutationBenchmark.run_benchmark(individual, EvoSynth::Mutations::Functions::FLIP_BOOLEAN)

	number = 2 ** (GENOME_SIZE - 1)
	add = number
	while add > 2
		add = add / 4
		number += add
	end

	individual = TestBinaryGenomeIndividual.new(number)
	puts "Running mutation benchmark (on BinaryGenome) with #{MUTATE_TIMES} mutations (genome=#{GENOME_SIZE}):"
	MutationBenchmark.run_benchmark(individual, EvoSynth::Mutations::Functions::FLIP_BINARY)

	individual = TestArrayGenomeIndividual.new([rand]*GENOME_SIZE)
	puts "Running mutation benchmark (on ArrayGenome filled with Float's) with #{MUTATE_TIMES} mutations (genome=#{GENOME_SIZE}):"
	mutation = EvoSynth::Mutations::GaussMutation.new
	MutationBenchmark.benchmark_mutation(mutation, individual)

	mutation = EvoSynth::Mutations::SelfAdaptiveGaussMutation.new
	MutationBenchmark.benchmark_mutation(mutation, individual)

	mutation = EvoSynth::Mutations::UniformRealMutation.new
	MutationBenchmark.benchmark_mutation(mutation, individual)
end