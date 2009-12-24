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
			@fitness = 0
			@genome.each { |gene| @fitness += 1 if gene }
			@fitness
		end
	end

	def MaxOnes.use_hillclimber(pop_size, generations)
		individual = MaxOnes::BinaryIndividual.new(10)
		hillclimber = EvoSynth::Strategies::Hillclimber.new(individual)
		result = hillclimber.run(pop_size * generations)
		puts "Hillclimber:\n#{result}"
	end

	def MaxOnes.use_population_hillclimber(pop_size, generations)
		population = EvoSynth::Population.new(pop_size) { MaxOnes::BinaryIndividual.new(10) }
		hillclimber = EvoSynth::Strategies::PopulationHillclimber.new(population)
		result = hillclimber.run(generations)
		puts "PopulationHillclimber\nbest: #{result.best}"
		puts "worst: #{result.worst}"
	end

	def MaxOnes.use_genetic_algorithm(pop_size, generations)
		population = EvoSynth::Population.new(pop_size) { MaxOnes::BinaryIndividual.new(10) }
		ga = EvoSynth::Strategies::GeneticAlgorithm.new(population)
		result = ga.run(generations)
		puts "GeneticAlgorithm\nbest: #{result.best}"
		puts "worst: #{result.worst}"
	end

	def MaxOnes.use_steady_state_ga(pop_size, generations)
		population = EvoSynth::Population.new(pop_size) { MaxOnes::BinaryIndividual.new(10) }
		steady_state_ga = EvoSynth::Strategies::SteadyStateGA.new(population)
		result = steady_state_ga.run(generations)
		puts "GeneticAlgorithm\nbest: #{result.best}"
		puts "worst: #{result.worst}"
	end
end

pop_size = 50
generations = 1000

require 'benchmark'

timing = Benchmark.measure do
	MaxOnes.use_hillclimber(pop_size, generations)
	MaxOnes.use_population_hillclimber(pop_size, generations)
	MaxOnes.use_genetic_algorithm(pop_size, generations)
	MaxOnes.use_steady_state_ga(pop_size, generations)
end
puts "\nRunning these algorithms took:\n#{timing}"