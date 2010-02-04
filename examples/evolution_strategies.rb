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


module EsExample

	DIMENSIONS = 10
	GENERATIONS = 1000
	POPULATION_SIZE = 25

	def EsExample.fitness_function(xs)
		EvoSynth::BenchmarkFuntions.sphere(xs)
	end

	class BenchmarkCalculator
		include EvoSynth::Core::FitnessCalculator

		def calculate_fitness(individual)
			EsExample.fitness_function(individual.genome)
		end

	end

	def EsExample.create_individual(genome_size, index)
		individual = EvoSynth::Core::MinimizingIndividual.new
		individual.genome = EvoSynth::Core::ArrayGenome.new(genome_size)
		individual.genome.map! { rand * 10.24 - 5.12 }
		individual
	end

	profile = Struct.new(:population, :fitness_calculator, :modification_frequency).new
	profile.fitness_calculator = BenchmarkCalculator.new
	profile.modification_frequency = 100
	profile.population = EvoSynth::Core::Population.new(POPULATION_SIZE) { EsExample.create_individual(DIMENSIONS, 0) }

	algorithm = EvoSynth::Algorithms::AdaptiveES.new(profile)
	algorithm.add_observer(EvoSynth::Util::ConsoleWriter.new(100, false))
	result = EvoSynth::Util.run_algorith_with_benchmark(algorithm, GENERATIONS)
	puts profile.fitness_calculator
	puts
	puts "Adaptive ES: fitness = #{profile.fitness_calculator.calculate_fitness(result.best)}"
	puts

	algorithm = EvoSynth::Algorithms::SelfAdaptiveES.new(profile)
	algorithm.add_observer(EvoSynth::Util::ConsoleWriter.new(100, false))
	result = EvoSynth::Util.run_algorith_with_benchmark(algorithm, GENERATIONS)
	puts profile.fitness_calculator
	puts
	puts "Self-Adaptive ES: fitness = #{profile.fitness_calculator.calculate_fitness(result.best)}"
	puts

end
