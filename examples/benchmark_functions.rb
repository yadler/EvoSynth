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


module BenchmarkFunctionExample

	VALUE_BITS = 16
	DIMENSIONS = 10
	GENERATIONS = 1000
	POPULATION_SIZE = 25

	def BenchmarkFunctionExample.fitness_function(xs)
		EvoSynth::BenchmarkFuntions.rastgrin(xs)
	end

	class BenchmarkCalculator
		include EvoSynth::Core::FitnessCalculator

		def decode(individual)
			values = []
			DIMENSIONS.times { |dim| values << EvoSynth::Decoder.binary_to_real(individual.genome[dim * VALUE_BITS, VALUE_BITS], -5.12, 5.12) }
			values
		end

		def calculate_fitness(individual)
			BenchmarkFunctionExample.fitness_function(decode(individual))
		end

	end


	class CCGABenchmarkCalculator
		include EvoSynth::Core::FitnessCalculator

		def initialize(populations)
			super()
			@populations = populations
		end

		def decode_rand(individual)
			values = (0..DIMENSIONS-1).to_a
			values.each do |index|
				if index == individual.population_index
					values[index] = EvoSynth::Decoder.binary_to_real(individual.genome, -5.12, 5.12)
				else
					values[index] = EvoSynth::Decoder.binary_to_real(@populations[index][rand(@populations[0].size)].genome, -5.12, 5.12)
				end
			end

			values
		end

		def decode(individual)
			values = (0..DIMENSIONS-1).to_a
			values.each do |index|
				if index == individual.population_index
					values[index] = EvoSynth::Decoder.binary_to_real(individual.genome, -5.12, 5.12)
				else
					values[index] = EvoSynth::Decoder.binary_to_real(@populations[0].best.genome, -5.12, 5.12)
				end
			end

			values
		end

		def calculate_fitness(individual)
			BenchmarkFunctionExample.fitness_function(decode(individual))
		end

		def calculate_intitial_fitness(individual)
			BenchmarkFunctionExample.fitness_function(decode_rand(individual))
		end

	end

	class CCGA2BenchmarkCalculator < CCGABenchmarkCalculator

		def calculate_fitness(individual)
			best = BenchmarkFunctionExample.fitness_function(decode(individual))
			rand = BenchmarkFunctionExample.fitness_function(decode_rand(individual))

			best < rand ? best : rand
		end

	end

	class CCGAIndividual < EvoSynth::Core::MinimizingIndividual
		attr_accessor :population_index

		def initialize(population_index)
			@population_index = population_index
			super()
		end
	end

	def BenchmarkFunctionExample.create_individual(genome_size, index)
		individual = CCGAIndividual.new(index)
		individual.genome = EvoSynth::Core::ArrayGenome.new(genome_size)
		individual.genome.map! { rand(2) > 0 ? true : false }
		individual
	end

	puts "# --- Elistism GA ------------------------------------------------------------------------------ #"

	profile = Struct.new(:individual, :mutation, :selection, :recombination, :population, :populations, :fitness_calculator, :recombination_probability).new
	profile.fitness_calculator = BenchmarkCalculator.new

	profile.mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
	profile.selection = EvoSynth::Selections::FitnessProportionalSelection.new
	profile.recombination = EvoSynth::Recombinations::KPointCrossover.new(2)
	profile.recombination_probability = 0.6

	profile.population = EvoSynth::Core::Population.new(POPULATION_SIZE) { BenchmarkFunctionExample.create_individual(VALUE_BITS*DIMENSIONS, 0) }

	algorithm = EvoSynth::Algorithms::ElitismGeneticAlgorithm.new(profile)
	algorithm.add_observer(EvoSynth::Util::ConsoleWriter.new(100, false))
	result = EvoSynth::Util.run_algorith_with_benchmark(algorithm, GENERATIONS)
	puts profile.fitness_calculator
	puts
	puts "Elistism GA: best 'combined' individual: #{profile.fitness_calculator.decode(result.best).to_s}"
	puts "Elistism GA: fitness = #{profile.fitness_calculator.calculate_fitness(result.best)}"
	puts

	puts "# --- CCGA-1 ----------------------------------------------------------------------------------- #"

	profile.populations = []
	DIMENSIONS.times do |dim|
		profile.populations << EvoSynth::Core::Population.new(POPULATION_SIZE) { BenchmarkFunctionExample.create_individual(VALUE_BITS, dim) }
	end

	profile.fitness_calculator = CCGABenchmarkCalculator.new(profile.populations)

	DIMENSIONS.times do |dim|
		profile.populations[dim].each { |individual| profile.fitness_calculator.calculate_intitial_fitness(individual) }
#		profile.populations[dim].each { |individual| puts "#{dim} == #{profile.fitness_calculator.decode_rand(individual).to_s}" }
	end
#	puts profile.populations

	algorithm = EvoSynth::Algorithms::CCGA.new(profile)
	algorithm.add_observer(EvoSynth::Util::ConsoleWriter.new(100, false))

	profile.fitness_calculator.reset_counters
	result = EvoSynth::Util.run_algorith_with_benchmark(algorithm, GENERATIONS)
	puts profile.fitness_calculator
	puts
	puts "CCGA-1: best 'combined' individual: #{result.to_s}"
	puts "CCGA-1: fitness = #{BenchmarkFunctionExample.fitness_function(result)}"
	puts

	puts "# --- CCGA-2 ----------------------------------------------------------------------------------- #"

	profile.populations = []
	DIMENSIONS.times do |dim|
		profile.populations << EvoSynth::Core::Population.new(POPULATION_SIZE) { BenchmarkFunctionExample.create_individual(VALUE_BITS, dim) }
	end

	profile.fitness_calculator = CCGA2BenchmarkCalculator.new(profile.populations)

	DIMENSIONS.times do |dim|
		profile.populations[dim].each { |individual| profile.fitness_calculator.calculate_intitial_fitness(individual) }
#		profile.populations[dim].each { |individual| puts "#{dim} == #{profile.fitness_calculator.decode_rand(individual).to_s}" }
	end
#	puts profile.populations

	algorithm = EvoSynth::Algorithms::CCGA.new(profile)
	algorithm.add_observer(EvoSynth::Util::ConsoleWriter.new(100, false))

	profile.fitness_calculator.reset_counters
	result = EvoSynth::Util.run_algorith_with_benchmark(algorithm, GENERATIONS)
	puts profile.fitness_calculator
	puts
	puts "CCGA-2: best 'combined' individual: #{result.to_s}"
	puts "CCGA-2: fitness = #{BenchmarkFunctionExample.fitness_function(result)}"
end
