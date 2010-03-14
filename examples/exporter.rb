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
	module Exporter

		VALUE_BITS = 16
		DIMENSIONS = 6
		POP_SIZE = 25
		GENERATIONS = 250
		GENOME_SIZE = VALUE_BITS * DIMENSIONS

		class ExporterEvaluator < EvoSynth::Evaluator
			def decode(individual)
				values = []
				DIMENSIONS.times { |dim| values << EvoSynth::Decoder.binary_to_real(individual.genome[dim * VALUE_BITS, VALUE_BITS], -5.12, 5.12) }
				values
			end

			def calculate_fitness(individual)
				EvoSynth::Problems::FloatBenchmarkFuntions.rastgrin(decode(individual))
			end
		end

		def Exporter.create_individual(genome_size)
			EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new(genome_size) { EvoSynth.rand_bool } )
		end

		evaluator = ExporterEvaluator.new
		profile = EvoSynth::Profile.new(
			:mutation			=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN),
#			:parent_selection	=> EvoSynth::Selections::FitnessProportionalSelection.new,
			:parent_selection	=> EvoSynth::Selections::SelectBest.new,
			:recombination		=> EvoSynth::Recombinations::KPointCrossover.new(2),
			:population			=> EvoSynth::Population.new(POP_SIZE) { Exporter.create_individual(GENOME_SIZE) },
			:evaluator			=> evaluator
		)

		evolver = EvoSynth::Evolvers::GeneticAlgorithm.new(profile)
		EvoSynth::Evolvers.add_strong_elistism(evolver)
		evolver.add_observer(EvoSynth::Output.create_console_logger(10,
			"gen"				=> ->{ evolver.generations_computed },
			"best"				=> ->{ profile.population.best.fitness },
			"worst"				=> ->{ profile.population.worst.fitness },
			"dist. diversity"	=> ->{ EvoSynth::Benchmark.diversity_distance_hamming(evolver.population) },
			"entropy diversity" => ->{ EvoSynth::Benchmark.diversity_entropy(evolver.population) },
			"mean fitness"		=> ->{ EvoSynth::Benchmark.population_fitness_mean(evolver.population) },
			"median fitness"	=> ->{ EvoSynth::Benchmark.population_fitness_median(evolver.population) }
		))

		plot_logger = EvoSynth::Output::Logger.new(5, true,
			"best fitness"		=> ->{ profile.population.best.fitness },
			"worst fitness"		=> ->{ profile.population.worst.fitness },
			"dist. diversity"	=> ->{ EvoSynth::Benchmark.diversity_distance_hamming(evolver.population) },
			"mean fitness"		=> ->{ EvoSynth::Benchmark.population_fitness_mean(evolver.population) },
			"median fitness"	=> ->{ EvoSynth::Benchmark.population_fitness_median(evolver.population) }
		)
		evolver.add_observer(plot_logger)
#		evaluator.add_observer(plot_logger)
		evolver.run_until_generations_reached(GENERATIONS)
		BASEPATH = File.expand_path(".")

		puts "\nexport to gnuplot..."
		EvoSynth::Output::GnuPlotExporter.new(plot_logger).export("Rastgrin function with Elistism GA")
		puts "export with gruff to #{BASEPATH + '/evosynth_viz_gruff.png'}..."
		EvoSynth::Output::GruffExporter.new(plot_logger).export("Rastgrin function with Elistism GA", BASEPATH + '/evosynth_viz_gruff.png')
		puts "export a CSV-File to #{BASEPATH + '/evosynth_export.csv'}..."
		EvoSynth::Output::CSVExporter.new(plot_logger, true).export(BASEPATH + '/evosynth_export.csv')

	end
end
