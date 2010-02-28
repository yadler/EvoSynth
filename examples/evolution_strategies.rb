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

		def EsExample.create_individual(genome_size, index)
			individual = EvoSynth::MinimizingIndividual.new
			individual.genome = EvoSynth::ArrayGenome.new(genome_size) { EvoSynth.rand * 10.24 - 5.12 }
			individual
		end

		base_population = EvoSynth::Population.new(POPULATION_SIZE) { EsExample.create_individual(DIMENSIONS, 0) }
		profile = EvoSynth::Core::Profile.new(
			:modification_frequency => 10,
			:evaluator				=> BenchmarkEvaluator.new
		)

		profile.population = base_population.deep_clone
		algorithm = EvoSynth::Evolvers::AdaptiveES.new(profile)
		algorithm.add_observer(EvoSynth::Output.create_console_logger(50,
			"generations"	=> ->{ algorithm.generations_computed },
			"bestfitness"   => ->{ algorithm.best_solution.fitness },
			"worstfitness"  => ->{ algorithm.worst_solution.fitness },
			"sigma"			=> ->{ algorithm.sigma },
			"success"	    => ->{ algorithm.success }
		))
		result = EvoSynth::Util.run_algorith_with_benchmark(algorithm, GENERATIONS)
		puts profile.evaluator
		puts
		puts "Adaptive ES: fitness = #{profile.evaluator.calculate_fitness(result.best)}"
		puts

		profile.population = base_population.deep_clone
		algorithm = EvoSynth::Evolvers::SelfAdaptiveES.new(profile)
		algorithm.add_observer(EvoSynth::Output.create_console_logger(50,
			"generations"	=> ->{ algorithm.generations_computed },
			"bestfitness"   => ->{ algorithm.best_solution.fitness },
			"worstfitness"  => ->{ algorithm.worst_solution.fitness },
			"sigma"			=> ->{ algorithm.sigma },
			"success"	    => ->{ algorithm.success }
		))

		result = EvoSynth::Util.run_algorith_with_benchmark(algorithm, GENERATIONS)
		puts profile.evaluator
		puts
		puts "Self-Adaptive ES: fitness = #{profile.evaluator.calculate_fitness(result.best)}"
		puts

		profile.population = base_population.deep_clone
		profile.tau = 1 / Math.sqrt(DIMENSIONS)
		algorithm = EvoSynth::Evolvers::DerandomizedES.new(profile)
		algorithm.add_observer(EvoSynth::Output.create_console_logger(50,
			"generations"	=> ->{ algorithm.generations_computed },
			"bestfitness"   => ->{ algorithm.best_solution.fitness },
			"worstfitness"  => ->{ algorithm.worst_solution.fitness },
			"sigma"			=> ->{ algorithm.sigma },
			"s"				=> ->{ algorithm.s.inspect }
		))

		result = EvoSynth::Util.run_algorith_with_benchmark(algorithm, GENERATIONS)
		puts profile.evaluator
		puts
		puts "Derandomized ES: fitness = #{profile.evaluator.calculate_fitness(result.best)}"
		puts
	end
end