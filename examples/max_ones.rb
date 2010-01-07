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

class TrueClass
	def flip
		!self
	end
end

class FalseClass
	def flip
		!self
	end
end


module MaxOnes

	class BinaryIndividual
		include EvoSynth::MaximizingIndividual

		def initialize(genome_size)
			@genome = EvoSynth::ArrayGenome.new(genome_size)
			@genome.map! { rand(2) > 0 ? true : false }
		end

		def calculate_fitness
			fitness = 0
			genome.each { |gene| fitness += 1 if gene }
			fitness
		end
	end

	def MaxOnes.use_hillclimber(pop_size, generations)
		individual = MaxOnes::BinaryIndividual.new(10)
		hillclimber = EvoSynth::Algorithms::Hillclimber.new(individual)
		result = hillclimber.run_until_generations_reached(pop_size * generations)
		puts hillclimber
		puts "\t #{result}"
	end

	def MaxOnes.run_algorithm(algorithm_class, pop_size, generations)
		algorithm = algorithm_class.new(EvoSynth::Population.new(pop_size) { MaxOnes::BinaryIndividual.new(10) })
		result = algorithm.run_until_generations_reached(generations)

		puts algorithm
		puts "\treached goal after #{algorithm.generations_run}"
		puts "\tbest individual: #{result.best}"
		puts "\tworst individual: #{result.worst}"
	end
end

pop_size = 25
generations = 1000

require 'benchmark'
#require 'profile'

timing = Benchmark.measure do
	MaxOnes.use_hillclimber(pop_size, generations)
	puts
	MaxOnes.run_algorithm(EvoSynth::Algorithms::PopulationHillclimber, pop_size, generations)
	puts
	MaxOnes.run_algorithm(EvoSynth::Algorithms::GeneticAlgorithm, pop_size, generations)
	puts
	MaxOnes.run_algorithm(EvoSynth::Algorithms::SteadyStateGA, pop_size, generations)
end
puts "\nRunning these algorithms took:\n#{timing}"