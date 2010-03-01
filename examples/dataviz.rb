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
#require 'profile'


module Examples
	module DataViz

		VALUE_BITS = 16
		DIMENSIONS = 6
		POP_SIZE = 25
		GENERATIONS = 100
		GENOME_SIZE = VALUE_BITS * DIMENSIONS

		class DataVizEvaluator < EvoSynth::Evaluator
			def decode(individual)
				values = []
				DIMENSIONS.times { |dim| values << EvoSynth::Decoder.binary_to_real(individual.genome[dim * VALUE_BITS, VALUE_BITS], -5.12, 5.12) }
				values
			end

			def calculate_fitness(individual)
				EvoSynth::Problems::FloatBenchmarkFuntions.rastgrin(decode(individual))
			end
		end

		def DataViz.create_individual(genome_size)
			EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new(genome_size) { EvoSynth.rand_bool } )
		end

		profile = EvoSynth::Profile.new(
			:mutation			=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN),
			:parent_selection	=> EvoSynth::Selections::FitnessProportionalSelection.new,
			:recombination		=> EvoSynth::Recombinations::KPointCrossover.new(2),
			:population			=> EvoSynth::Population.new(POP_SIZE) { DataViz.create_individual(GENOME_SIZE) },
			:evaluator			=> DataVizEvaluator.new
		)

		profile.evaluator.reset_counters
		algorithm = EvoSynth::Evolvers::ElitismGeneticAlgorithm.new(profile)
		algorithm.add_observer(EvoSynth::Output.create_console_logger(10,
			"gen" => ->{ algorithm.generations_computed },
			"best" => ->{ profile.population.best.fitness },
			"worst" => ->{ profile.population.worst.fitness }
		))

		plot_logger = EvoSynth::Output::Logger.new(10, true,
			"best fitness" => ->{ profile.population.best.fitness },
#			"foo" => ->{ algorithm.generations_computed },
#			"bar" => ->{ 100 - algorithm.generations_computed },
			"worst fitness" => ->{ profile.population.worst.fitness }
		)
		algorithm.add_observer(plot_logger)

		algorithm.run_until_generations_reached(GENERATIONS)

		EvoSynth::Output.draw_with_gnuplot(plot_logger, "Rastgrin function with Elistism GA")
		EvoSynth::Output.draw_with_gruff(plot_logger, "Rastgrin function with Elistism GA", '/home/yves/Desktop/evosynth_viz_gruff.png')

	end
end
