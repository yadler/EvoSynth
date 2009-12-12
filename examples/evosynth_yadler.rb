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

module GraphColouring

	class Graph
		attr_reader :node_count
		attr_reader :matrix

		# reads the node count from grapg-file
		def count_nodes(file_name)
			File.open(file_name) do |file|
				file.each_line do |line|
					next if line !~ /^p\D*(\d+)/
					return Integer($1)
				end
			end
		end


		# creates empty 2-dimensional array filled with 0's
		def create_empty_matrix
			@matrix = Array.new(@node_count)

			@matrix.each_index do |x|
				@matrix[x] = Array.new(@node_count)
				@matrix[x].each_index { |y| @matrix[x][y] =  0 }
			end
		end


		# reads a graph file
		def read_file(file_name)
			@node_count = count_nodes(file_name)
			create_empty_matrix

			File.open(file_name) do |file|
				file.each_line do |line|
					# skip everything except edges
					next if line !~ /^e/

					#match the begin and end node of that edge
					line =~ /(\d+)\s*(\d+)/
					@matrix[Integer($1)-1][Integer($2)-1] = 1
				end
			end
		end

	end

	class ColouringIndividual
		include EvoSynth::Individual


		def initialize(graph)
			@graph = graph
			@genome = EvoSynth::Genome.new(graph.node_count)
		end


		def verletzungen
			if @genome.changed
				@verletzungen = 0

				@graph.matrix.each_index do |x|
					@graph.matrix[x].each_index do |y|

						if @graph.matrix[x][y] == 1 && @genome[x] == @genome[y]
							@verletzungen += 1
						end

					end
				end
			end

			return @verletzungen
		end


		def fitness
			if @genome.changed
				@fitness = 0.0
				@fitness += Set.new(@genome).size
				@fitness *= (verletzungen + 1)
				@genome.changed = false
			end

			return @fitness
		end

	end

end

# Simple testing...

# setup problem
filename = "tests/testdata/graph_colouring/myciel5.col"
graph = GraphColouring::Graph.new
graph.read_file(filename)

# intialize population
pop = EvoSynth::Population.new(10) { GraphColouring::ColouringIndividual.new(graph) }

puts pop
