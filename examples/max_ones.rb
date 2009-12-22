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

		def fitness
			@fitness = 0
			@genome.each { |gene| @fitness += 1 if gene }
			@fitness
		end
	end

	def MaxOnes.use_hillclimber
		individual = MaxOnes::BinaryIndividual.new(10)
		hillclimber = EvoSynth::Strategies::Hillclimber.new(individual)
		result = hillclimber.run(100)
		puts "Hillclimber:\n#{result}"
	end

	def MaxOnes.use_population_hillclimber
		population = EvoSynth::Population.new(10) { MaxOnes::BinaryIndividual.new(10) }
		hillclimber = EvoSynth::Strategies::PopulationHillclimber.new(population)
		result = hillclimber.run(10)
		puts "PopulationHillclimber\nbest: #{result.best}"
		puts "worst: #{result.worst}"
	end

	def MaxOnes.use_genetic_algorithm
		population = EvoSynth::Population.new(10) { MaxOnes::BinaryIndividual.new(10) }
		ga = EvoSynth::Strategies::GeneticAlgorithm.new(population)
		result = ga.run(10)
		puts "GeneticAlgorithm\nbest: #{result.best}"
		puts "worst: #{result.worst}"
	end
end

MaxOnes.use_hillclimber
MaxOnes.use_population_hillclimber
MaxOnes.use_genetic_algorithm