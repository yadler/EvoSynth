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


module GraphColouring

	MUTATION_RATE = 5
	MAX_COLORS = 10
	GENERATIONS = 1000
	INDIVIDUALS = 10
	GOAL = 5
	FLIP_GRAPH_COLOUR = lambda { |gene| rand(gene + 2) }


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


	class ColourFitnessCalculator
		include EvoSynth::Core::FitnessCalculator

		def initialize(graph)
			@graph = graph
			super()
		end

		def verletzungen(genome)
			verletzungen = 0
			@graph.matrix.each_index do |row, col|
				if @graph.matrix[row, col] == 1 && genome[row] == genome[col]
					verletzungen += 1
				end
			end
			verletzungen
		end

		def calculate_fitness(individual)
			fitness = 0.0 + individual.genome.uniq.size * (verletzungen(individual.genome) + 1)
			fitness
		end
	end


	def GraphColouring.create_random_individual(graph)
		genome = EvoSynth::Core::ArrayGenome.new(graph.node_count)
		max_color = rand(genome.size > MAX_COLORS ? MAX_COLORS : genome.size) + 1
		genome.map! { |gene| rand(max_color)}
		genome.map! { |gene| gene % genome.uniq.size }
		inidividual = EvoSynth::Core::MinimizingIndividual.new(genome)
		inidividual
	end



	require 'benchmark'
	#require 'profile'

	def GraphColouring.algorithm_profile(graph)
		profile = Struct.new(:mutation, :selection, :recombination, :population, :fitness_calculator).new
		profile.fitness_calculator = GraphColouring::ColourFitnessCalculator.new(graph)
		profile.mutation = EvoSynth::Mutations::BinaryMutation.new(FLIP_GRAPH_COLOUR, 0.01)
		profile.selection = EvoSynth::Selections::RouletteWheelSelection.new
		profile.population = EvoSynth::Core::Population.new(INDIVIDUALS) { GraphColouring.create_random_individual(graph) }
		profile.recombination = EvoSynth::Recombinations::KPointCrossover.new
		profile
	end

	graph = GraphColouring::Graph.new("testdata/graph_colouring/myciel4.col")
	profile = GraphColouring.algorithm_profile(graph)
	base_population = profile.population

	EvoSynth::Algorithms.constants.each do |algorithm|
		algorithm_class = EvoSynth::Algorithms.const_get(algorithm)
		next unless defined? algorithm_class.new

		profile.population = base_population.deep_clone
		EvoSynth::Util.run_algorith_with_benchmark(algorithm_class.new(profile), GENERATIONS) { |gen, best| best.fitness <= GOAL || gen > GENERATIONS } rescue next
	end

end