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
	module MaxOnes

		GENOME_SIZE = 50
		POP_SIZE = 25
		MAX_EVALUATIONS = 5000

		# this is just for the sake of demonstration stuff - you could also use
		# EvoSynth::Problems::BinaryBenchmarkFuntions.count_ones()

		class MaxOnesEvaluator < EvoSynth::Evaluator
			def calculate_fitness(individual)
				individual.genome.inject(0.0) { |fitness, gene| fitness += gene ? 1 : 0 }
			end
		end

		def MaxOnes.create_individual
			EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(GENOME_SIZE) { EvoSynth.rand_bool } )
		end

		profile = EvoSynth::Profile.new(
			:individual			=> MaxOnes.create_individual,
			:population			=> EvoSynth::Population.new(POP_SIZE) { MaxOnes.create_individual },
			:evaluator			=> MaxOnes::MaxOnesEvaluator.new,
			:mutation			=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
		)

		# ---------------------------- Use simple Hillclimber ---------------------------- #

		evolver = EvoSynth::Evolvers::Hillclimber.new(profile)
		evolver.add_observer(EvoSynth::Output.create_console_logger(500,
			"generations"	=> ->{ evolver.generations_computed },
			"bestfitness"   => ->{ evolver.best_solution.fitness },
			"worstfitness"  => ->{ evolver.worst_solution.fitness }
		))

		puts "\nRunning Hillclimber...\n"
		result = evolver.run_until { profile.evaluator.called < MAX_EVALUATIONS }
		puts "\nIndividual after evolution:  #{profile.individual}"

		# --------------------------- Use GA with weak elistism --------------------------- #

		profile.evaluator.reset_counters
		evolver = EvoSynth::Evolvers::GeneticAlgorithm.new(profile)
		EvoSynth::Evolvers.add_weak_elistism(evolver)
		evolver.add_observer(EvoSynth::Output.create_console_logger(50,
			"generations"	=> ->{ evolver.generations_computed },
			"bestfitness"   => ->{ evolver.best_solution.fitness },
			"worstfitness"  => ->{ evolver.worst_solution.fitness },
			"diversity"		=> ->{ EvoSynth::Benchmark.diversity_distance_hamming(evolver.population) }
		))

		puts "\nRunning Genetic Algorithm with elitism...\n"
		result = evolver.run_until { profile.evaluator.called < MAX_EVALUATIONS }
		puts "\nBest Individual after evolution:  #{result.best}"
	end
end