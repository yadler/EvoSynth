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
			sum_a = @genome[0..@partition_border].inject(0) { |sum, n| n.nil? ? sum : sum + n }
			sum_b = @genome[@partition_border + 1..@genome.size].inject(0) { |sum, n| n.nil? ? sum : sum + n }
			(sum_a - sum_b).abs
		end

		def to_s
			"fitness = #{fitness}, partition_a = [#{@genome[0..@partition_border]}], partition_b = [#{@genome[@partition_border + 1..@genome.size]}]"
		end

	end

	class PartitionMutation

		def mutate(individual)
			# FIXME this mutation is absolute bullshit - maybe I should go for a 2 array genome
			mutated = individual.deep_clone
			genome = mutated.genome

			if rand(2) > 0
				rand_index = rand(genome.size - mutated.partition_border)
				foo = genome.delete_at(mutated.partition_border + rand_index)
				genome.insert(0, foo)
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

	def Partitionproblem.get_genome_from(problem)
		genome = EvoSynth::Genome.new(problem)
	end

	def Partitionproblem.run_algorithm(algorithm_class, population, generations)
		algorithm = algorithm_class.new(population)

		# Setup custom mutation and never recombine (as it would destroy our genome)
		algorithm.mutation = PartitionMutation.new
		algorithm.recombination = EvoSynth::Recombinations::Identity.new if defined? algorithm.recombination

		# algorithm.selection = EvoSynth::Selections::SelectBest.new if defined? algorithm.selection
		algorithm.selection = EvoSynth::Selections::TournamentSelection.new(3) if defined? algorithm.selection
		# algorithm.selection = EvoSynth::Selections::StochasticUniversalSampling.new if defined? algorithm.selection
		# algorithm.selection = EvoSynth::Selections::NStageTournamentSelection.new(3) if defined? algorithm.selection
		# algorithm.selection = EvoSynth::Selections::FitnessProportionalSelection.new if defined? algorithm.selection

		result = algorithm.run_until_generations_reached(generations)
		puts algorithm
		puts "\treached goal after #{algorithm.generations_run}"
		puts "\tbest individual: #{result.best}"
		puts "\tworst individual: #{result.worst}"
	end
	def evolve

	end

end

POPULATION_SIZE = 1
GENERATIONS = 100000

problem = Partitionproblem::Testdata.gen_layer_set
population = EvoSynth::Population.new(POPULATION_SIZE) { Partitionproblem::PartitionIndividual.new(Partitionproblem.get_genome_from(problem)) }

puts "Starting with the following population:"
puts "\tbest individual: #{population.best}"
puts "\tworst individual: #{population.worst}"
puts

Partitionproblem.run_algorithm(EvoSynth::Algorithms::PopulationHillclimber, population.deep_clone, GENERATIONS)
Partitionproblem.run_algorithm(EvoSynth::Algorithms::SteadyStateGA, population.deep_clone, GENERATIONS)
#Partitionproblem.run_algorithm(EvoSynth::Algorithms::GeneticAlgorithm, population.deep_clone, GENERATIONS)

puts
puts "The startpopulation should not have changed:"
puts "\tbest individual: #{population.best}"
puts "\tworst individual: #{population.worst}"