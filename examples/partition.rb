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
		include Comparable

		attr_accessor :partition_a, :partition_b

		def initialize(partition_a, partition_b)
			@partition_a = partition_a;
			@partition_b = partition_b;
		end

		def fitness
			if @partition_a.changed || @partition_b.changed
				sum_a = @partition_a.inject(0) { |sum, n| sum + n }
				sum_b = @partition_b.inject(0) { |sum, n| sum + n }
				@fitness = (sum_a - sum_b).abs
			end

			@fitness
		end

		def deep_clone
			my_clone = self.clone
			my_clone.partition_a = self.partition_a.clone
			my_clone.partition_b = self.partition_b.clone
			my_clone
		end

		def <=>(anOther)
			cmp = fitness <=> anOther.fitness
			-1 * cmp
		end

		def to_s
			"fitness = #{fitness}, partition_a = #{@partition_a}, partition_b = #{@partition_a}"
		end

	end

	class PartitionMutation

		def mutate(individual)
			mutated = individual.deep_clone
			part_a, part_b = mutated.partition_a, mutated.partition_b

			if rand(2) > 0
				part_a << part_b.delete_at(rand(part_b.size)) unless mutated.partition_b.empty?
			else
				part_b << part_a.delete_at(rand(part_a.size)) unless mutated.partition_a.empty?
			end

			mutated
		end

		def to_s
			"custom made mutation for the partition problem"
		end

	end

	module Testdata

		def Testdata.gen_tiny_set
			problem = Array.new(25)
			problem.fill { |i| i }
		end

		def Testdata.gen_layer_set
			problem = Set.new
			problem.add(rand(1000) * rand(1000)) while problem.size < 200
			problem.add(rand(1000)) while problem.size < 1000
			problem.to_a
		end

		def Testdata.gen_standard_set
			problem = Array.new
			1000.times { |i| problem.insert(-1, i)  }
			problem
		end

		def Testdata.gen_random_set
			problem = Set.new
			problem.add(rand(1000000)) while problem.size < 1000
			problem.to_a
		end

		def Testdata.gen_big_set
			problem = Set.new
			problem.add(rand(10000) * 100) while problem.size < 1000
			problem.to_a
		end
	end

	def Partitionproblem.get_new_individual_from(problem)
		border = rand(problem.size)
		part_a, part_b = EvoSynth::Genome.new, EvoSynth::Genome.new

		problem.size.times do
			|index| index < border ? part_a << problem[index] : part_b << problem[index]
		end

		Partitionproblem::PartitionIndividual.new(part_a, part_b)
	end

	def Partitionproblem.run_algorithm(algorithm_class, population, generations)
		algorithm = algorithm_class.new(population)

		# Setup custom mutation and never recombine (as it would destroy our genome)
		algorithm.mutation = PartitionMutation.new
		algorithm.recombination = EvoSynth::Recombinations::Identity.new if defined? algorithm.recombination

		# The tournament selection seems to be the best performing
		algorithm.selection = EvoSynth::Selections::TournamentSelection.new(3) if defined? algorithm.selection

		result = algorithm.run_until_generations_reached(generations)
		puts algorithm
		puts "\treached goal after #{algorithm.generations_run}"
		puts "\tbest individual: #{result.best}"
		puts "\tworst individual: #{result.worst}"
	end

end

POPULATION_SIZE = 10
GENERATIONS = 1000

problem = Partitionproblem::Testdata.gen_layer_set
population = EvoSynth::Population.new(POPULATION_SIZE) { Partitionproblem.get_new_individual_from(problem) }

puts "Starting with the following population:"
puts "\tbest individual: #{population.best}"
puts "\tworst individual: #{population.worst}"
puts

Partitionproblem.run_algorithm(EvoSynth::Algorithms::PopulationHillclimber, population.deep_clone, GENERATIONS)
Partitionproblem.run_algorithm(EvoSynth::Algorithms::SteadyStateGA, population.deep_clone, GENERATIONS)
Partitionproblem.run_algorithm(EvoSynth::Algorithms::GeneticAlgorithm, population.deep_clone, GENERATIONS)
