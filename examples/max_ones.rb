#    Copyright (C) 2009 Yves Adler <yves.adler@googlemail.com>
#
#    This file is part of EvoSynth, a framework for rapid prototyping of
#    evolutionary and genetic algorithms.
#
#    EvoSynth is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    EvoSynth is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with EvoSynth.  If not, see <http://www.gnu.org/licenses/>.

# Author::    Yves Adler (mailto:yves.adler@googlemail.com)
# Copyright:: Copyright (C) 2009 Yves Adler
# License::   LGPLv3

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
			@genome = EvoSynth::Genome.new(genome_size)
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