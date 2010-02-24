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


module Examples
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
						pr *= EvoSynth.rand
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
						break if line =~ /DISPLAY_DATA_SECTION/
						next if line !~ /^\s*\d+/

						line =~ /(\d+)\s*(\d+.\d+)\s*(\d+.\d+)/
						nodes << line.split
					end
				end

				nodes
			end

			def create_matrix(nodes)
				@matrix = EvoSynth::Util::MDArray.new(nodes.size, nodes.size)
				@matrix.each_index { |x,y| @matrix[x,y] = nodes[x][y].to_f }
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


		class AntFitnessCalculator < EvoSynth::Evaluator

			def initialize(problem_matrix)
				@problem_matrix = problem_matrix
				super()
			end

			def calculate_fitness(individual)
				fitness = 0.0

				individual.genome.each_with_index do |node, index|
					index_two = (index + 1) % individual.genome.size
					fitness += @problem_matrix.distance(node, individual.genome[index_two])
				end

				fitness
			end

		end


		class SimpleAntMutation

			def initialize(problem_matrix, pheromon, start, exploration_weight = 0.5)
				@problem_matrix = problem_matrix
				@pheromon = pheromon
				@start = start
				@exploration_weight = exploration_weight
			end

			def mutate(ant)
				mutated = ant.deep_clone
				mutated.genome[1..mutated.genome.size-1] = []
				mutated.genome = rand_route
				mutated
			end

			def to_s
				"simple ant mutation <start: #{@start}, exploration_weight: #{@exploration_weight}>"
			end

			private

			def rand_route
				genome = EvoSynth::ArrayGenome.new
				genome << @start

				(@problem_matrix.size - 1).times do
					if EvoSynth.rand < @exploration_weight
						genome << @problem_matrix.get_next_node(genome, @pheromon, genome.last)
					else
						genome << @problem_matrix.get_nearest_node(genome, genome.last)
					end
				end

				genome
			end

		end


		def Ants.algorithm_profile(matrix, pheromon)
			ant_mutation = Ants::SimpleAntMutation.new(matrix, pheromon, 1, 0.2)

			population = EvoSynth::Population.new(10) do
				ant = EvoSynth::MinimizingIndividual.new(EvoSynth::ArrayGenome.new)
				ant_mutation.mutate(ant)
			end

			combined_mutation = EvoSynth::MetaOperators::ProportionalCombinedOperator.new
			combined_mutation.add(EvoSynth::Mutations::InversionMutation.new, 0.25)
			combined_mutation.add(ant_mutation, 0.75)

			EvoSynth::Core::Profile.new(
				:mutation			=> combined_mutation,
				:parent_selection	=> EvoSynth::Selections::FitnessProportionalSelection.new,
				:population			=> population,
				:recombination		=> EvoSynth::Recombinations::PartiallyMappedCrossover.new,
				:evaluator			=> Ants::AntFitnessCalculator.new(matrix)
			)
		end

		matrix = Ants::ProblemMatrix.new('testdata/tsp/bays29.tsp')
		puts "read testdata/ant/bays29.tsp - matrix contains #{matrix.size} nodes..."

		PHEROMON = Ants::Pheromon.new(matrix.size)

		class EvoSynth::Evolvers::ElitismGeneticAlgorithm
			alias :ant_next_generation :next_generation

			def next_generation
				ant_next_generation
				PHEROMON.update(@population);
			end
		end

		profile = Ants.algorithm_profile(matrix, PHEROMON)

		opt_tour = [1,28,6,12,9,5,26,29,3,2,20,10,4,15,18,17,14,22,11,19,25,7,23,27,8,24,16,13,21].map! { |num| num -= 1 }
		optimal = EvoSynth::MinimizingIndividual.new(EvoSynth::ArrayGenome.new(opt_tour))
		profile.evaluator.calculate_and_set_fitness(optimal)
		puts "Optimal Individual for this problem: #{optimal}"

		puts "Best Individual before evolution: #{profile.population.best}"

		algorithm = EvoSynth::Evolvers::ElitismGeneticAlgorithm.new(profile)
		algorithm.add_observer(EvoSynth::Util::ConsoleWriter.new(50))

		result = algorithm.run_until_generations_reached(1000)
		puts algorithm

		puts "Best Individual after evolution:  #{result.best}"
		puts "SHIT!" if result.best.genome.size != result.best.genome.uniq.size
	end
end