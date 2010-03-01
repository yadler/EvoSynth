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
require 'matrix'


module Examples
	module Ants

		class Pheromon
			attr_accessor :matrix

			def initialize(node_count, evaporation_weight = 0.7)
				@evaporation_weight = evaporation_weight
				@matrix = Matrix.zero(node_count).collect { |i| i + 1.0 }
			end

			def update(ants)
				@matrix = @matrix.collect { |i| i * @evaporation_weight }

				ants.each do |ant|
					ant.genome.each_with_index do |node, index|
						break if (index + 1) >= ant.genome.size

						# FIXME: this is pretty inefficient
						columns = @matrix.column_vectors
						columns[ant.genome[index + 1]] = columns[ant.genome[index + 1]].map { |i| i * 100 / ant.fitness }
						@matrix = Matrix.columns(columns)
					end
				end
			end

			def to_s
				@matrix.to_s
			end

		end

		# FIXME: this mutation is seriously broken

		class SimpleAntMutation

			def initialize(tsp, pheromon, start, exploration_weight = 0.5, distance_weight = 2.0)
				@tsp = tsp
				@pheromon = pheromon
				@start = start
				@exploration_weight = exploration_weight
				@distance_weight = distance_weight
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

			def get_next_node(existing_route, pheromon, last_node)
				best_pr = 0.0
				best_node = nil
				route = existing_route.to_set
				raise "shit!" if last_node.nil?
				distances = @tsp.matrix.row(last_node).to_a

				distances.each_with_index do |distance, node_index|
					unless route.include?(node_index)
						pr = pheromon.matrix[last_node, node_index]
						pr *= (1.0 / distance) ** @distance_weight
						pr /= get_sum(existing_route, pheromon, last_node)
						pr *= EvoSynth.rand
					else
						pr = 0.0
					end

					if pr >= best_pr
						best_node = node_index
						best_pr = pr
					end
				end

				best_node
			end

			def get_sum(existing_route, pheromon, last_node)
				sum = 0.0
				route = existing_route.to_set
				distances = @tsp.matrix.row(last_node).to_a

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
				raise "shit-2!" if last_node.nil?
				distances = @tsp.matrix.row(last_node).to_a

				distances.each_with_index do |distance_to_node, node_index|
					next if route.include?(node_index)

					if best_distance > distance_to_node
						best_distance = distance_to_node
						best_node = node_index
					end
				end

				best_node
			end

			private

			def rand_route
				genome = EvoSynth::ArrayGenome.new
				genome << @start

				(@tsp.size - 1).times do
					puts genome.inspect if genome.last.nil?

					if EvoSynth.rand < @exploration_weight
						genome << get_next_node(genome, @pheromon, genome.last)
					else
						genome << get_nearest_node(genome, genome.last)
					end
				end

				genome
			end

		end


		def Ants.evolver_profile(tsp, pheromon)
			ant_mutation = Ants::SimpleAntMutation.new(tsp, pheromon, 1, 0.2)

			population = EvoSynth::Population.new(10) do
				ant = EvoSynth::MinimizingIndividual.new(EvoSynth::ArrayGenome.new)
				ant_mutation.mutate(ant)
			end

#			combined_mutation = EvoSynth::MetaOperators::ProportionalCombinedOperator.new
#			combined_mutation.add(EvoSynth::Mutations::InversionMutation.new, 0.25)
#			combined_mutation.add(ant_mutation, 0.75)

			EvoSynth::Profile.new(
				:mutation			=> EvoSynth::Mutations::InversionMutation.new,
				:parent_selection	=> EvoSynth::Selections::FitnessProportionalSelection.new,
				:population			=> population,
				:recombination		=> EvoSynth::Recombinations::PartiallyMappedCrossover.new,
				:evaluator			=> tsp
			)
		end

		tsp = EvoSynth::Problems::TSP.new('testdata/tsp/bays29.tsp')
		puts "read testdata/ant/bays29.tsp - matrix contains #{tsp.size} nodes..."

		PHEROMON = Ants::Pheromon.new(tsp.size)

		class EvoSynth::Evolvers::GeneticAlgorithm
			alias :ant_next_generation :next_generation

			def next_generation
				ant_next_generation
				PHEROMON.update(@population);
			end
		end

		profile = Ants.evolver_profile(tsp, PHEROMON)

		opt_tour = [1,28,6,12,9,5,26,29,3,2,20,10,4,15,18,17,14,22,11,19,25,7,23,27,8,24,16,13,21].map! { |num| num -= 1 }
		optimal = EvoSynth::MinimizingIndividual.new(EvoSynth::ArrayGenome.new(opt_tour))
		profile.evaluator.calculate_and_set_fitness(optimal)
		puts "Optimal Individual for this problem: #{optimal}"

		puts "Best Individual before evolution: #{profile.population.best}"

		evolver = EvoSynth::Evolvers::GeneticAlgorithm.new(profile)
		EvoSynth::Evolvers.add_elistism(evolver)
		evolver.add_observer(EvoSynth::Output.create_console_logger(25,
			"generations"	=> ->{ evolver.generations_computed },
			"bestfitness"   => ->{ evolver.best_solution.fitness },
			"worstfitness"  => ->{ evolver.worst_solution.fitness }
		))

		result = evolver.run_until_generations_reached(1000)
		puts evolver

		puts "Best Individual after evolution:  #{result.best}"
		puts "SHIT!" if result.best.genome.size != result.best.genome.uniq.size
	end
end