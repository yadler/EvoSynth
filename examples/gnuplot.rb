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
require 'gnuplot'
#require 'profile'


module Gnuplot

	VALUE_BITS = 16
	DIMENSIONS = 6
	POP_SIZE = 25
	GENERATIONS = 1000
	GENOME_SIZE = VALUE_BITS * DIMENSIONS

	class FitnessCalculator
		include EvoSynth::Core::FitnessCalculator

		def decode(individual)
			values = []
			DIMENSIONS.times { |dim| values << EvoSynth::Decoder.binary_to_real(individual.genome[dim * VALUE_BITS, VALUE_BITS], -5.12, 5.12) }
			values
		end

		def calculate_fitness(individual)
			EvoSynth::BenchmarkFuntions.rastgrin(decode(individual))
		end

	end

	def Gnuplot.create_individual(genome_size)
		individual = EvoSynth::Core::MinimizingIndividual.new
		individual.genome = EvoSynth::Core::ArrayGenome.new(genome_size)
		individual.genome.map! { rand(2) > 0 ? true : false }
		individual
	end

	profile = Struct.new(:mutation, :selection, :recombination, :population, :fitness_calculator).new
	profile.mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
	profile.selection = EvoSynth::Selections::FitnessProportionalSelection.new
	profile.recombination = EvoSynth::Recombinations::KPointCrossover.new(2)
	profile.fitness_calculator = FitnessCalculator.new
	profile.population = EvoSynth::Core::Population.new(POP_SIZE) { Gnuplot.create_individual(GENOME_SIZE) }

	profile.fitness_calculator.reset_counters
	algorithm = EvoSynth::Algorithms::ElitismGeneticAlgorithm.new(profile)

	data = []
	algorithm.add_observer(EvoSynth::Util::UniversalLogger.new(10, false,
		{"gen" => ->{ algorithm.generations_computed },
		"best" => ->{ profile.population.best.fitness },
		"worst" => ->{ profile.population.worst.fitness }},
		->(line) { data << line }
	))

	algorithm.run_until_generations_reached(GENERATIONS)

	# for details take a look at http://rgplot.rubyforge.org/

	Gnuplot.open do |gp|
		Gnuplot::Plot.new( gp ) do |plot|

			plot.title  "Rastgrin function with Elistism GA"
			plot.ylabel "fitness"
			plot.xlabel "generation"

			x, y1, y2 = [], [], []
			data.each do |record|
				x << record[0]
				y1 << record[1]
				y2 << record[2]
			end

			plot.data << Gnuplot::DataSet.new( [x, y1] ) do |ds|
				ds.with = "lines"
				ds.title = "best individual"
			end

			plot.data << Gnuplot::DataSet.new( [x, y2] ) do |ds|
				ds.with = "lines"
				ds.title = "worst individual"
			end
		end
	end


end