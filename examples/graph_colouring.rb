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


module Examples
	module GraphColouring

		MAX_COLORS = 10
		GENERATIONS = 10000
		INDIVIDUALS = 10
		GOAL = 5
		FLIP_GRAPH_COLOUR = lambda { |gene| EvoSynth.rand(gene + 2) }

		def GraphColouring.create_random_individual(graph_evaluator)
			genome = EvoSynth::ArrayGenome.new(graph_evaluator.node_count)
			max_color = EvoSynth.rand(genome.size > MAX_COLORS ? MAX_COLORS : genome.size) + 1
			genome.map! { |gene| EvoSynth.rand(max_color)}
			genome.map! { |gene| gene % genome.uniq.size }
			inidividual = EvoSynth::MinimizingIndividual.new(genome)
			inidividual
		end

		graph_evaluator = nil
		begin
			graph_evaluator = EvoSynth::Problems::GraphColouring.new("testdata/myciel4.col")
		rescue
			puts "Could not load test data. Please see testdata/README for instructions..."
			exit(0)
		end

		configuration = EvoSynth::Configuration.new(
			:mutation			=> EvoSynth::Mutations::BinaryMutation.new(FLIP_GRAPH_COLOUR, 0.01),
			:parent_selection	=> EvoSynth::Selections::RouletteWheelSelection.new,
			:recombination		=> EvoSynth::Recombinations::KPointCrossover.new,
			:population			=> EvoSynth::Population.new(INDIVIDUALS) { GraphColouring.create_random_individual(graph_evaluator) },
			:evaluator			=> graph_evaluator
		)

		evolver = EvoSynth::Evolvers::SteadyStateGA.new(configuration)
		logger = EvoSynth::Output::Logger.new(500) do |log|
			log.add_column("generations",   ->{ evolver.generations_computed })
			log.add_column("best fitness",  ->{ evolver.best_solution.fitness })
			log.add_column("worst fitness", ->{ evolver.worst_solution.fitness })
			log.add_observer(EvoSynth::Output::ConsoleWriter.new)
		end
		evolver.add_observer(logger)

		evolver.run_until { |gen, best| best.fitness <= GOAL || gen > GENERATIONS }
		puts "", configuration.population.best
	end
end