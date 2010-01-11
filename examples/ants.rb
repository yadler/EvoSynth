#	Copyright (c) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
#
#	Permission is hereby granted, free of charge, to any person
#	obtaining a copy of this software and associated documentation
#	files (the "Software"), to deal in the Software without
#	restriction, including without limitation the rights to use,
#	copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the
#	Software is furnished to do so, subject to the following
#	conditions:
#
#	The above copyright notice and this permission notice shall be
#	included in all copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#	OTHER DEALINGS IN THE SOFTWARE.


require 'evosynth'
require 'set'


module Ants

	class ProblemMatrix

		def initialize(file_name, distance_weight = 2)
			@distance_weight = distance_weight

			nodes = read_nodes_from_file(file_name)
			create_matrix(nodes)
		end

		def get_next_node(existing_route, pheromon, last_node)
			best_pr = 0.0
			best_node = nil
			route = existing_route.to_set
			distances = @matrix.row_to_a(last_node)

			distances.each_with_index do |distance, node_index|
				unless route.include?(node_index)
					pr = pheromon.matrix[last_node, node_index]
					pr *= (1.0 / distance) ** @distance_weight
					pr /= get_sum(existing_route, pheromon, last_node)
					pr *= rand
				else
					pr = 0.0
				end

				if pr > best_pr
					best_node = node_index
					best_pr = pr
				end
			end

			best_node
		end

		def get_sum(existing_route, pheromon, last_node)
			sum = 0.0
			route = existing_route.to_set
			distances = @matrix.row_to_a(last_node)

			distances.each_with_index do |distance, node_index|
				next if route.include?(node_index)
				sum += pheromon.matrix[last_node, node_index] * (distance ** @distance_weight)
			end

			sum
		end

		def get_nearest_node(existing_route, last_node)
			best_distance = Float::MAX
			best_node = nil
			route = existing_route.to_set
			distances = @matrix.row_to_a(last_node)

			distances.each_with_index do |distance_to_node, node_index|
				next if route.include?(node_index)

				if best_distance > distance_to_node
					best_distance = distance_to_node
					best_node = node_index
				end
			end

			best_node
		end

		def distance(from, to)
			@matrix[from, to]
		end

		def size
			@matrix.cols
		end

		def to_s
			@matrix.each_row { |row| puts row.inspect }
		end

		private

		def read_nodes_from_file(file_name)
			nodes = []

			File.open(file_name) do |file|
				file.each_line do |line|
					next if line !~ /^\s*\d+/

					line =~ /(\d+)\s*(\d+.\d+)\s*(\d+.\d+)/
					nodes << [$2.to_f, $3.to_f]
				end
			end

			nodes
		end

		def create_matrix(nodes)
			@matrix = EvoSynth::Util::MDArray.new(nodes.size, nodes.size)

			@matrix.each_index do |x,y|
				@matrix[x,y] = calc_distance(nodes[x], nodes[y])
			end
		end

		def calc_distance(from, to)
			Math.sqrt( (from[0] - to[1])**2 + (from[1] - to[1])**2 )
		end
	end

	class Pheromon
		attr_accessor :matrix

		def initialize(node_count, evaporation_weight = 0.7)
			@evaporation_weight = evaporation_weight

			@matrix = EvoSynth::Util::MDArray.new(node_count, node_count)
			@matrix.each_index { |x, y| @matrix[x, y] = 1.0 }
		end

		def update(ants)
			@matrix.each_index { |x, y| @matrix[x,y] *= @evaporation_weight }

			ants.each do |ant|
				ant.genome.each_with_index do |node, index|
					break if (index + 1) >= ant.genome.size
					@matrix[node, ant.genome[index + 1]] += 100 / ant.fitness
				end
			end
		end

		def to_s
			@matrix.each_row { |row| puts row.inspect}
		end

	end

	class AntIndividual
		include EvoSynth::MinimizingIndividual

		def initialize(problem_matrix, pheromon, start, exploration_weight = 0.5)
			@exploration_weight = exploration_weight

			@problem_matrix = problem_matrix
			@pheromon = pheromon

			@genome = EvoSynth::ArrayGenome.new
			@genome << start
		end

		def generate_route!
			(@problem_matrix.size - 1).times do
				if rand < @exploration_weight
					@genome << @problem_matrix.get_next_node(@genome, @pheromon, @genome.last)
				else
					@genome << @problem_matrix.get_nearest_node(@genome, @genome.last)
				end
			end
		end

		def calculate_fitness
			fitness = 0.0

			@genome.each_with_index do |node, index|
				break if (index + 1) >= @genome.size
				fitness += @problem_matrix.distance(node, @genome[index + 1])
			end

			fitness
		end
	end

	class SimpleAntMutation

		def mutate(ant)
			mutated = ant.deep_clone
			mutated.genome[1..mutated.genome.size-1] = []
			mutated.generate_route!
			mutated
		end

	end
end

matrix = Ants::ProblemMatrix.new('testdata/ant/bays29.tsp')
puts "read testdata/ant/bays29.tsp - matrix contains #{matrix.size} nodes..."

PHEROMON = Ants::Pheromon.new(matrix.size)

class EvoSynth::Algorithms::SteadyStateGA
	alias :original_next_generation :next_generation

	def next_generation
		original_next_generation
		PHEROMON.update(@population);
	end
end

population = EvoSynth::Population.new(10) do
	ant = Ants::AntIndividual.new(matrix, PHEROMON, 1)
	ant.generate_route!
	ant
end

puts "Best Individual before evolution: #{population.best}"

algorithm = EvoSynth::Algorithms::SteadyStateGA.new(population)
algorithm.mutation = EvoSynth::Mutations::MixingMutation.new

result = algorithm.run_until_generations_reached(1000)
puts algorithm
#puts "\t #{result}"
puts "Best Individual after evolution:  #{result.best}"