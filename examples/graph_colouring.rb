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

	def GraphColouring.another_mutation(individual)
		individual.genome.map! { |gene| rand(individual.genome[index] + 1) if rand(100) >= MUTATION_RATE }
	end

end

generations = 100
individuals = 10

require 'benchmark'
#require 'profile'

timing = Benchmark.measure do
	graph = GraphColouring::Graph.new("testdata/graph_colouring/myciel4.col")

	population = EvoSynth::Population.new(individuals) { GraphColouring::ColouringIndividual.new(graph) }
	hillclimber = EvoSynth::Algorithms::PopulationHillclimber.new(population)
	result = hillclimber.run_until_generations_reached(generations)
	puts "PopulationHillclimber\nbest: #{result.best}"
	puts "worst: #{result.worst}"

	population = EvoSynth::Population.new(individuals) { GraphColouring::ColouringIndividual.new(graph) }
	ga = EvoSynth::Algorithms::GeneticAlgorithm.new(population)
	result = ga.run_until_generations_reached(generations)
	puts "GeneticAlgorithm\nbest: #{result.best}"
	puts "worst: #{result.worst}"

	population = EvoSynth::Population.new(individuals) { GraphColouring::ColouringIndividual.new(graph) }
	steady_state = EvoSynth::Algorithms::SteadyStateGA.new(population)
	result = steady_state.run_until_generations_reached(generations)
	puts "SteadyStateGA\nbest: #{result.best}"
	puts "worst: #{result.worst}"
end
puts "\nRunning these algorithms took:\n#{timing}"