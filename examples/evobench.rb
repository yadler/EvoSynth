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


		profile = EvoSynth::Profile.new(
			:population			=> EvoSynth::Population.new(POP_SIZE) { EvoBench.create_individual },
			:evaluator			=> EvoBench::Evaluator.new,
			:mutation			=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
		)

		# --------------------------- Use GA with weak elistism --------------------------- #

		profile.evaluator.reset_counters
		evolver = EvoSynth::Evolvers::GeneticAlgorithm.new(profile)
		EvoSynth::Evolvers.add_weak_elistism(evolver)

		logger = EvoSynth::Output::Logger.new(1, true,
			"generations"		=> ->{ evolver.generations_computed },
			"bestfitness"		=> ->{ evolver.best_solution.fitness },
			"worstfitness"		=> ->{ evolver.worst_solution.fitness },
			"dist. diversity"	=> ->{ EvoSynth::EvoBench.diversity_distance_hamming(evolver.population) },
			"entropy diversity" => ->{ EvoSynth::EvoBench.diversity_entropy(evolver.population) }
		)
#		logger.add_observer(EvoSynth::Output::ConsoleWriter.new(20))
		evolver.add_observer(logger)

		seeds = []
		RUNS.times { |run| seeds << EvoSynth::rand(99999999999) }

		puts "running GA with elitism"

		datasets1 = []
		RUNS.times do |run|
			print "."
			EvoSynth::srand(seeds[run])
			evolver.population = EvoSynth::Population.new(POP_SIZE) { EvoBench.create_individual }
			evolver.run_until_generations_reached(MAX_GENERATIONS)
			datasets1 << logger.data

			profile.evaluator.reset_counters
			logger.clear_data
		end

		# --------------------------- Use GA WITHOUT weak elistism --------------------------- #

		profile.evaluator.reset_counters
		evolver = EvoSynth::Evolvers::GeneticAlgorithm.new(profile)

		logger = EvoSynth::Output::Logger.new(1, true,
			"generations"		=> ->{ evolver.generations_computed },
			"bestfitness"		=> ->{ evolver.best_solution.fitness },
			"worstfitness"		=> ->{ evolver.worst_solution.fitness },
			"dist. diversity"	=> ->{ EvoSynth::EvoBench.diversity_distance_hamming(evolver.population) },
			"entropy diversity" => ->{ EvoSynth::EvoBench.diversity_entropy(evolver.population) }
		)
#		logger.add_observer(EvoSynth::Output::ConsoleWriter.new(20))
		evolver.add_observer(logger)

		puts "\nrunning GA without elitism"

		datasets2 = []
		RUNS.times do |run|
			print "."
			EvoSynth::srand(seeds[run])
			evolver.population = EvoSynth::Population.new(POP_SIZE) { EvoBench.create_individual }
			evolver.run_until_generations_reached(MAX_GENERATIONS)
			datasets2 << logger.data

			profile.evaluator.reset_counters
			logger.clear_data
		end

		with = {}
		datasets1.each do |dataset|
			dataset.each_row_with_index do |row, index|
				with[index] = [] unless with.has_key?(index)
				with[index] << row[1]
			end
		end

		without = {}
		datasets2.each do |dataset|
			dataset.each_row_with_index do |row, index|
				without[index] = [] unless without.has_key?(index)
				without[index] << row[1]
			end
		end

#		puts with.inspect
#		puts without.inspect

		puts ""
		with.each_pair do |index, row|
			t_value = EvoSynth::EvoBench.t_test(row, without[index])
			error_prob = EvoSynth::EvoBench.t_probability(t_value, RUNS)

			puts "#{index}\t#{t_value}\t#{error_prob}"
		end
	end
end