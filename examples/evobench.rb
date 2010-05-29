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

		comparator = EvoSynth::EvoBench::Comparator.new(RUNS)
		comparator.set_goal { |gen, best| gen > MAX_GENERATIONS }
		comparator.reset_evolvers_with() { |evolver| evolver.population = base_population.deep_clone }

		comparator.add_evolver(ga_elistism)
		comparator.add_evolver(ga)
		comparator.collect_data!
		comparator.compare(ga, ga_elistism)
	end
end