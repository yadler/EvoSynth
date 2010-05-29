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

		def EvoBench.create_individual
			EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(GENOME_SIZE) { EvoSynth.rand_bool } )
		end

		def EvoBench.test_run(evolver, &reset_block)
			logger = EvoSynth::Logger.new(1, true, "best fitness" => ->{ evolver.best_solution.fitness })
			evolver.add_observer(logger)

			# collect data:
			puts "running #{evolver.to_s}..."
			datasets = []
			RUNS.times do |run|
				print "."
				yield evolver
				evolver.run_until_generations_reached(MAX_GENERATIONS)
				datasets << logger.data

				evolver.evaluator.reset_counters
				logger.clear_data
			end
			puts "\n\n"

			# create data hash:
			datahash = {}
			datasets.each do |dataset|
				dataset.each_row_with_index do |row, index|
					datahash[index] = [] unless datahash.has_key?(index)
					datahash[index] << row[0] # best fitness
				end
			end

			datahash
		end

		def EvoBench.compare(evolver_one, evolver_two, &reset_block)
			results_one = EvoBench.test_run(evolver_one, &reset_block)
			results_two = EvoBench.test_run(evolver_two, &reset_block)

			puts "comparison:\n"
			results_one.each_pair do |index, row|
				t_value = EvoSynth::EvoBench.t_test(row, results_two[index])
				error_prob = EvoSynth::EvoBench.t_probability(t_value, RUNS)

				puts "#{index}\tbest (one) = #{EvoSynth::EvoBench.mean(row)}\tbest (two) = #{EvoSynth::EvoBench.mean(results_two[index])}\tt-value=#{t_value}\terror prob.=#{error_prob}"
			end
		end


		base_population = EvoSynth::Population.new(POP_SIZE) { EvoBench.create_individual }

		configuration = EvoSynth::Configuration.new do |cfg|
			cfg.population = base_population
			cfg.evaluator = EvoBench::Evaluator.new
			cfg.mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
		end

		# ------------------------------------------------------------------------------------ #

		ga_elistism = EvoSynth::Evolvers::GeneticAlgorithm.new(configuration)
		EvoSynth::Evolvers.add_weak_elistism(ga_elistism)
		ga = EvoSynth::Evolvers::GeneticAlgorithm.new(configuration)

		EvoBench.compare(ga_elistism, ga) do |evolver|
			evolver.population = base_population.deep_clone
		end
	end
end