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


module MaxOnes

	class BinaryIndividual
		include EvoSynth::Core::MaximizingIndividual

		def initialize(genome_size)
			@genome = EvoSynth::Core::ArrayGenome.new(genome_size)
			@genome.map! { rand(2) > 0 ? true : false }
		end

		def calculate_fitness
			fitness = 0
			genome.each { |gene| fitness += 1 if gene }
			fitness
		end
	end

	def MaxOnes.use_hillclimber
		individual = MaxOnes::BinaryIndividual.new(10)
		mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
		hillclimber = EvoSynth::Algorithms::Hillclimber.new(individual, mutation)
		result = hillclimber.run_until_generations_reached(POP_SIZE * GENERATIONS)
		puts hillclimber
		puts "\t #{result}"
	end

	def MaxOnes.run_algorithm(algorithm)
		result = algorithm.run_until_generations_reached(GENERATIONS)

		puts algorithm
		puts "\treached goal after #{algorithm.generations_run}"
		puts "\tbest individual: #{result.best}"
		puts "\tworst individual: #{result.worst}"
	end
end

POP_SIZE = 25
GENERATIONS = 1000

require 'benchmark'
#require 'profile'

timing = Benchmark.measure do
	MaxOnes.use_hillclimber
end
puts "\nRunning these algorithm took:\n#{timing}"
puts

timing = Benchmark.measure do
	population = EvoSynth::Core::Population.new(POP_SIZE) { MaxOnes::BinaryIndividual.new(10) }
	mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
	algorithm = EvoSynth::Algorithms::PopulationHillclimber.new(population, mutation)
	MaxOnes.run_algorithm(algorithm)
end
puts "\nRunning these algorithm took:\n#{timing}"
puts

timing = Benchmark.measure do
	population = EvoSynth::Core::Population.new(POP_SIZE) { MaxOnes::BinaryIndividual.new(10) }
	mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
	algorithm = EvoSynth::Algorithms::GeneticAlgorithm.new(population, mutation)
	MaxOnes.run_algorithm(algorithm)
end
puts "\nRunning these algorithm took:\n#{timing}"
puts

timing = Benchmark.measure do
	population = EvoSynth::Core::Population.new(POP_SIZE) { MaxOnes::BinaryIndividual.new(10) }
	mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
	algorithm = EvoSynth::Algorithms::ElitismGeneticAlgorithm.new(population, mutation)
	MaxOnes.run_algorithm(algorithm)
end
puts "\nRunning these algorithm took:\n#{timing}"
puts

timing = Benchmark.measure do
	population = EvoSynth::Core::Population.new(POP_SIZE) { MaxOnes::BinaryIndividual.new(10) }
	mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
	algorithm = EvoSynth::Algorithms::SteadyStateGA.new(population, mutation)
	MaxOnes.run_algorithm(algorithm)
end
puts "\nRunning these algorithm took:\n#{timing}"
