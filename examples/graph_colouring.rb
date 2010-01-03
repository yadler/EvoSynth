#    Copyright (C) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
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


require 'evosynth'

# add flip to fixnum (our gene) for mutation
class Fixnum
	def flip
		rand(self + 2)
	end
end

module GraphColouring
	MUTATION_RATE = 5
	MAX_COLORS = 10

	class Graph
		attr_reader :node_count
		attr_reader :matrix

		def initialize(filename)
			read_file(filename)
		end
		
		private

		# reads the node count from grapg-file
		def get_node_count(file_name)
			File.open(file_name).each_line do |line|
				next if line !~ /^p\D*(\d+)/
				return Integer($1)
			end
		end

		# reads a graph file
		def read_file(file_name)
			@node_count = get_node_count(file_name)
			@matrix = EvoSynth::Util::MDArray.new(@node_count, @node_count, 0)

			File.open(file_name).each_line do |line|
				next if line !~ /^e/
				line =~ /(\d+)\s*(\d+)/
				@matrix[Integer($1)-1, Integer($2)-1] = 1
			end
		end

	end


	class ColouringIndividual
		include EvoSynth::MinimizingIndividual

		def initialize(graph)
			@graph = graph
			@genome = EvoSynth::Genome.new(graph.node_count)
			randomize_genome
		end

		private

		def randomize_genome
			max_color = rand(@genome.size > MAX_COLORS ? MAX_COLORS : @genome.size) + 1
			@genome.map! { |gene| rand(max_color)}
			@genome.map! { |gene| gene % get_uniq.size }
		end
		
		# workaround because of the rather ugly behaviour of rubys arr.uniq
		def get_uniq
			unique_colors = Array.new
			@genome.each { |gene| unique_colors << gene if !unique_colors.include?(gene)}
			unique_colors
		end

		def verletzungen
			verletzungen = 0
			@graph.matrix.each_index do |row, col|
				if @graph.matrix[row, col] == 1 && @genome[row] == @genome[col]
					verletzungen += 1
				end
			end
			verletzungen
		end

		def calculate_fitness
			fitness = 0.0 + get_uniq.size * (verletzungen + 1)
			fitness
		end

	end

	class CustomMutation
		def mutate(individual)
			mutated = individual.deep_clone
			genome = mutated.genome
			genome.size.times do |index|
				genome[index] = rand(genome[index] + 1) if rand(100) >= MUTATION_RATE
			end

			mutated
		end

		def to_s
			"custom made mutation for graph colouring"
		end
	end


	BEST = 5
	GENERATIONS = 1000
	INDIVIDUALS = 25
	USE_CUSTOM_MUATION = false

	require 'benchmark'
	#require 'profile'

	def GraphColouring.run_algorithm(algorithm_class)
		population = EvoSynth::Population.new(INDIVIDUALS) { GraphColouring::ColouringIndividual.new(GRAPH) }
		puts "Starting with:"
		puts "\tbest individual: #{population.best}"
		puts "\tworst individual: #{population.worst}"

		algorithm = algorithm_class.new(population)
		algorithm.mutation = GraphColouring::CustomMutation.new if USE_CUSTOM_MUATION
		algorithm.mutation = EvoSynth::Mutations::Identity.new
		algorithm.selection = EvoSynth::Selections::SelectBest.new
		result = algorithm.run_until() { |gen, best| gen >= GENERATIONS || best.fitness < BEST }

		puts algorithm
		puts "\treached goal after #{algorithm.generations_run}"
		puts "\tbest individual: #{result.best}"
		puts "\tworst individual: #{result.worst}"
	end


	timing = Benchmark.measure do
		GRAPH = GraphColouring::Graph.new("testdata/graph_colouring/myciel4.col")

#		GraphColouring.run_algorithm EvoSynth::Algorithms::PopulationHillclimber
		puts
		GraphColouring.run_algorithm EvoSynth::Algorithms::GeneticAlgorithm
		puts
#		GraphColouring.run_algorithm EvoSynth::Algorithms::SteadyStateGA
	end
	puts "\nRunning these algorithms took:\n#{timing}"

end