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

#		comparator = EvoSynth::EvoBench::Comparator.new(RUNS) do |cmp|
#			cmp.set_goal { |gen, best| gen > MAX_GENERATIONS }
#			cmp.reset_evolvers_with { |evolver| evolver.population = base_population.deep_clone }
#			cmp.add_evolver(ga_elistism)
#			cmp.add_evolver(ga)
#		end
#
#		comparator.collect_data!
#		comparator.compare(ga, ga_elistism)

#		logger = EvoSynth::Logger.create(1, false, :best_fitness)

#		test_run = EvoSynth::EvoBench::TestRun.new(ga_elistism) do |run|
#			run.set_goal { |gen, best| gen > MAX_GENERATIONS }
#			run.reset_evolvers_with { |evolver| evolver.population = base_population.deep_clone }
#		end
#		puts test_run.start!.to_s

		experiment = EvoSynth::EvoBench::Experiment.new(configuration) do |ex|
			ex.try_evolver(ga)
			ex.try_evolver(ga_elistism)
			ex.try_parameter(:mutation, "m1")
			ex.try_parameter(:mutation, "m2")
			ex.try_parameter(:mutation, "m3")
			ex.try_parameter(:recombination, "r1")
			ex.try_parameter(:recombination, "r2")
			ex.try_parameter(:recombination, "r3")
			ex.try_parameter(:selection, "s1")
			ex.try_parameter(:selection, "s2")
		end
#		puts experiment
#		experiment.start!
		experiment.create_experiment_plan
	end
end