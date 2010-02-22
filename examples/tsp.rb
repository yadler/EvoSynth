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


module TSP

	class ProblemMatrix
		attr_reader :matrix

		def initialize(file_name, distance_weight = 2)
			@distance_weight = distance_weight

			nodes = read_nodes_from_file(file_name)
			create_matrix(nodes)
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


	class TSPFitnessCalculator
		include EvoSynth::Core::FitnessCalculator

		def initialize(problem_matix)
			super()
			@problem_matrix = problem_matix
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

	def TSP.create_individual(problem_matrix)
		individual = EvoSynth::Core::MinimizingIndividual.new
		shuffeld = (0..problem_matrix.size - 1).to_a.sort_by { rand(2) }
		individual.genome = EvoSynth::Core::ArrayGenome.new(shuffeld)
		individual
	end

	def TSP.optimal_tour(matrix)
		optimal = TSP.create_individual(matrix)
		opt_tour = [1,28,6,12,9,5,26,29,3,2,20,10,4,15,18,17,14,22,11,19,25,7,23,27,8,24,16,13,21].map! { |num| num -= 1 }
		optimal.genome = EvoSynth::Core::ArrayGenome.new(opt_tour)
		optimal
	end

	matrix = TSP::ProblemMatrix.new('testdata/tsp/bays29.tsp')
	optimal_tour = TSP.optimal_tour(matrix)

	profile = EvoSynth::Core::Profile.new(
		:individual			=> TSP.create_individual(matrix),
		:mutation			=> EvoSynth::Mutations::CombinedMutation.new(EvoSynth::Mutations::InversionMutation.new,
																		 EvoSynth::Mutations::ShiftingMutation.new,
																		 EvoSynth::Mutations::MixingMutation.new),
		:parent_selection	=> EvoSynth::Selections::TournamentSelection.new(3),
		:recombination		=> EvoSynth::Recombinations::EdgeRecombination.new,
		:population			=> EvoSynth::Core::Population.new(100) { TSP.create_individual(matrix) },
		:fitness_calculator => TSP::TSPFitnessCalculator.new(matrix)
	)
	profile.fitness_calculator.calculate_and_set_fitness(optimal_tour)

	puts "read testdata/ant/bays29.tsp - matrix contains #{matrix.size} nodes..."
	puts "Optimal Individual for this problem: #{optimal_tour}"
	puts "Best Individual before evolution: #{profile.population.best}"

	algorithm = EvoSynth::Evolvers::ElitismGeneticAlgorithm.new(profile)
	algorithm.add_observer(EvoSynth::Util::ConsoleWriter.new(50, false))

	puts "\nRunning #{algorithm}...\n"
	result = algorithm.run_until_generations_reached(1000)
	puts "\nBest Individual after evolution:  #{result.best}"
end