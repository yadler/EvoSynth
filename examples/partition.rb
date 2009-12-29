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

require 'set'
require 'evosynth'

module Partitionproblem

	class PartitionIndividual
		include EvoSynth::MinimizingIndividual

		attr_accessor :partition_border

		def initialize(genome)
			@genome = genome
			@partition_border = rand(genome.size - 1)
			@genome.changed = true
		end

		def calculate_fitness
			sum_a = @genome[0..@partition_border].inject(0) { |sum, n| sum + n }
			sum_b = @genome[@partition_border + 1..@genome.size].inject(0) { |sum, n| sum + n }
			(sum_a - sum_b).abs
		end

		def to_s
			"fitness = #{fitness}, partition_a = [#{@genome[0..@partition_border]}], partition_b = [#{@genome[@partition_border + 1..@genome.size]}]"
		end

	end

	class PartitionMutation

		def mutate(individual)
			mutated = individual.deep_clone
			genome = mutated.genome

			if rand(2) > 0
				rand_index = rand(genome.size - mutated.partition_border)
				genome.insert(0, genome.delete_at(mutated.partition_border + rand_index))
				mutated.partition_border += 1
			else
				rand_index = rand(mutated.partition_border)
				genome.insert(mutated.partition_border, genome.delete_at(rand_index))
				mutated.partition_border -= 1
			end

			mutated
		end

		def to_s
			"custom made mutation for the partition problem"
		end
	end


	def Partitionproblem.gen_tiny_set
		set = Array.new(25)
		set.fill { |i| i }
	end

	def Partitionproblem.gen_layer_set
		set = Set.new
		set.add(rand(1000) * rand(1000)) while set.size < 200
		set.add(rand(1000)) while set.size < 1000
		set.to_a
	end

	def Partitionproblem.get_genome_from(set)
		genome = EvoSynth::Genome.new(set.size)
		genome.each_index { |index| genome[index] = set[index] }
	end

	def Partitionproblem.run_algorithm(algorithm_class, population_size, generations)
		population = EvoSynth::Population.new(population_size) { Partitionproblem::PartitionIndividual.new(get_genome_from(gen_layer_set)) }
		algorithm = algorithm_class.new(population)
		algorithm.mutation = PartitionMutation.new

		result = algorithm.run_until_generations_reached(generations)
		puts algorithm
		puts "\treached goal after #{algorithm.generations_run}"
		puts "\tbest individual: #{result.best}"
		puts "\tworst individual: #{result.worst}"
	end
	def evolve

	end

end

POPULATION_SIZE = 20
GENERATIONS = 1000

#Partitionproblem.run_algorithm(EvoSynth::Algorithms::PopulationHillclimber, POPULATION_SIZE, GENERATIONS)
Partitionproblem.run_algorithm(EvoSynth::Algorithms::SteadyStateGA, POPULATION_SIZE, GENERATIONS)