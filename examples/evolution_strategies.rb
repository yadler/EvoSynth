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
	module EsExample

		DIMENSIONS = 5
		GENERATIONS = 500
		POPULATION_SIZE = 25

		def EsExample.fitness_function(xs)
			EvoSynth::Problems::FloatBenchmarkFuntions.sphere(xs)
		end

		class BenchmarkEvaluator < EvoSynth::Evaluator
			def calculate_fitness(individual)
				EsExample.fitness_function(individual.genome)
			end
		end

		def EsExample.create_individual(genome_size)
			individual = EvoSynth::MinimizingIndividual.new
			individual.genome = EvoSynth::ArrayGenome.new(genome_size) { EvoSynth.rand * 10.24 - 5.12 }
			individual
		end

		def EsExample.run(evolver_class, configuration, base_population)
			configuration.evaluator.reset_counters
			configuration.population = base_population.deep_clone
			evolver = evolver_class.new(configuration)

			logger = EvoSynth::Output::Logger.new(50) do |log|
				log.add_column("generations",   ->{ evolver.generations_computed })
				log.add_column("best fitness",  ->{ evolver.best_solution.fitness })
				log.add_column("worst fitness", ->{ evolver.worst_solution.fitness })
				log.add_column("sigma",         ->{ evolver.sigma })
				log.add_column("success",       ->{ evolver.success })
				log.add_column("s",             ->{ evolver.s.inspect })
				log.add_column("diversity",     ->{ EvoSynth::EvoBench.diversity_distance_float(evolver.population) })
				log.add_observer(EvoSynth::Output::ConsoleWriter.new)
			end
			evolver.add_observer(logger)

			puts "\nRunning #{evolver}...\n"
			result = evolver.run_until_generations_reached(GENERATIONS)
			puts "", configuration.evaluator
			puts "\nfitness = #{configuration.evaluator.calculate_fitness(result.best)}"
			puts
		end

		base_population = EvoSynth::Population.new(POPULATION_SIZE) { EsExample.create_individual(DIMENSIONS) }
		configuration = EvoSynth::Configuration.new(
			:modification_frequency => 10,
			:evaluator				=> BenchmarkEvaluator.new,
			:tau					=> 1 / Math.sqrt(DIMENSIONS)
		)

		EsExample.run(EvoSynth::Evolvers::AdaptiveES, configuration, base_population)
		EsExample.run(EvoSynth::Evolvers::SelfAdaptiveES, configuration, base_population)
		EsExample.run(EvoSynth::Evolvers::DerandomizedES, configuration, base_population)
	end
end