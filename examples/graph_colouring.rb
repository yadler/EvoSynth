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
require 'delegate'


module GraphColouring
	MUTATION_RATE = 5
	MAX_COLORS = 10

	class Graph
		attr_reader :node_count
		attr_reader :matrix

		# reads the node count from grapg-file

		def get_node_count(file_name)
			File.open(file_name) do |file|
				file.each_line do |line|
					next if line !~ /^p\D*(\d+)/
					return Integer($1)
				end
			end
		end

		# reads a graph file

		def read_file(file_name)
			@node_count = get_node_count(file_name)
			@matrix = EvoSynth::Util::MDArray.new(@node_count, @node_count, 0)

			File.open(file_name) do |file|
				file.each_line do |line|
					next if line !~ /^e/
					line =~ /(\d+)\s*(\d+)/
					@matrix[Integer($1)-1, Integer($2)-1] = 1
				end
			end
		end

	end


	class ColorGene < DelegateClass(Fixnum)
		def !
			ColorGene.new(rand(self + 1))
		end
	end


	class ColouringIndividual
		include EvoSynth::MinimizingIndividual

		def initialize(graph)
			@graph = graph
			@genome = EvoSynth::Genome.new(graph.node_count)
			randomize_genome
		end

		def randomize_genome
			max_color = rand(@genome.size > MAX_COLORS ? MAX_COLORS : @genome.size) + 1
			@genome.map! { |gene| ColorGene.new(rand(max_color))}
			@genome.map! { |gene| ColorGene.new(gene % get_uniq.size) }
		end

		# workaround because of the rather ugly behaviour of rubys arr.uniq
		def get_uniq
			unique_colors = Array.new()
			@genome.each { |gene| unique_colors << gene if !unique_colors.include?(gene)}
			unique_colors
		end

		def verletzungen
			verletzungen = 0
			@graph.matrix.each do |row, col|
				if @graph.matrix[row, col] == 1 && @genome[row] == @genome[col]
					verletzungen += 1
				end
			end
			verletzungen
		end

		def calculate_fitness
			fitness = 0.0
			fitness += get_uniq.size
			fitness *= (verletzungen + 1)
			fitness
		end

	end

	def GraphColouring.another_mutation(individual)
		individual.genome.map! { |gene| rand(individual.genome[index] + 1) if rand(100) >= MUTATION_RATE }
	end

end

# Simple testing...

# setup problem
filename = "tests/testdata/graph_colouring/myciel4.col"
graph = GraphColouring::Graph.new
graph.read_file(filename)

# intialize population
pop = EvoSynth::Population.new(25) { GraphColouring::ColouringIndividual.new(graph) }
hillclimber = EvoSynth::Strategies::PopulationHillclimber.new(pop)
result = hillclimber.run(1000)
puts "PopulationHillclimber\nbest: " + result.best.to_s
puts "worst: " + result.worst.to_s
