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


module SPk

	class SPkFitnessCalculator
		include EvoSynth::Core::FitnessCalculator

		def initialize(k)
			@k = k
			super()
		end

		def calculate_fitness(individual)
			fitness = 0.0

			ones = individual.genome.inject(0) { |ones, gene| ones += 1 if gene }

			if is_valid(individual.genome)
				fitness = individual.genome.size * (ones + 1)
			else
				fitness = individual.genome.size - ones
			end

			fitness
		end


		def is_valid(genome)
			valid = false

			if genome.changed
				len_of_ones = calc_length_of_ones(genome)
				max_k = (genome.size.to_f / (3.0 * @k*@k).to_f).ceil

				valid = true if !len_of_ones.nil? && len_of_ones / @k <= max_k && len_of_ones % @k == 0
			end

			valid
		end

		def calc_length_of_ones(genome)
			count, len_of_ones = 0, 0
			end_of_ones, end_of_zeros = false, false

			genome.each do |gene|
				end_of_ones_reached = !gene && !end_of_ones
				end_of_zeros_reached = gene && end_of_ones && !end_of_zeros

				if end_of_ones_reached
					len_of_ones = count
					end_of_ones = true
				elsif end_of_zeros_reached
					end_of_zeros = true
				end

				count += 1
			end

			len_of_ones = count if !end_of_ones
			len_of_ones = nil if end_of_zeros
			len_of_ones
		end

	end

	def SPk.create_individual(genome_size)
		genome = EvoSynth::Core::ArrayGenome.new(genome_size)
		genome.map! { rand(2) > 0 ? true : false }
		inidividual = EvoSynth::Core::MaximizingIndividual.new(genome)
		inidividual
	end

	K = 2
	GENOME_SIZE = 16
	GOAL = 48
	MAX_GENERATIONS = 1000
	INDIVIDUALS = 25

	#require 'profile'

	profile = Struct.new(:individual, :mutation, :selection, :recombination, :population, :fitness_calculator).new
	profile.fitness_calculator = SPkFitnessCalculator.new(K)
	profile.individual = SPk.create_individual(GENOME_SIZE)
	profile.mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
	profile.selection = EvoSynth::Selections::FitnessProportionalSelection.new
	profile.recombination = EvoSynth::Recombinations::KPointCrossover.new(2)
	base_population = EvoSynth::Core::Population.new(INDIVIDUALS) { SPk.create_individual(GENOME_SIZE) }

	profile.population = base_population.deep_clone
	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::Hillclimber, profile, MAX_GENERATIONS * INDIVIDUALS)

	profile.population = base_population.deep_clone
	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::PopulationHillclimber, profile) { |gen| gen >= MAX_GENERATIONS}

	profile.population = base_population.deep_clone
	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::GeneticAlgorithm, profile) { |gen, best| best.fitness >= GOAL || gen > MAX_GENERATIONS }

	profile.population = base_population.deep_clone
	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::ElitismGeneticAlgorithm, profile) { |gen| gen >= MAX_GENERATIONS}

	profile.population = base_population.deep_clone
	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::SteadyStateGA, profile) { |gen| gen >= MAX_GENERATIONS}

end