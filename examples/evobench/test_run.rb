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


require 'evosynth'
#require 'profile'

module Examples
	module EvoBench

		GENOME_SIZE = 50
		POP_SIZE = 25
		MAX_GENERATIONS = 50
		RUNS = 10

		class Evaluator < EvoSynth::Evaluator
			def calculate_fitness(individual)
				EvoSynth::Problems::BinaryBenchmarkFuntions.count_ones(individual.genome)
			end
		end

		class ProgressOutput
			def update(experiment, test_runs_computed, total_runs)
				puts "test run #{test_runs_computed} of #{total_runs} computed..."
			end
		end

		base_population = EvoSynth::Population.new(POP_SIZE) do
			EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(GENOME_SIZE) { EvoSynth.rand_bool } )
		end

		ga = EvoSynth::Evolvers::GeneticAlgorithm.new do |evolver|
			evolver.population = base_population
			evolver.evaluator = EvoBench::Evaluator.new
			evolver.mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
		end

		test_run = EvoSynth::EvoBench::TestRun.new(ga) do |run|
			run.set_goal { |evolver| evolver.generations_computed == MAX_GENERATIONS }
			run.reset_evolvers_with { |evolver| evolver.population = base_population.deep_clone }
			run.repetitions = 3
		end
		results = test_run.start!
		results.each { |result| puts result.elapsed_time }

		puts "\nserialization/deserialization...\n"
		File.open("run_results", "w+") { |file| Marshal.dump(results, file) }
		loaded_results = Marshal.load(File.open("run_results"))
		File.delete("run_results")

		loaded_results.each { |result| puts result.elapsed_time }
	end
end