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


module MaxOnes

	POP_SIZE = 25
	GENERATIONS = 1000

	class OnesCalculator
		include EvoSynth::Core::FitnessCalculator

		def calculate_fitness(individual)
			fitness = 0.0
			individual.genome.each { |gene| fitness += 1 if gene }
			fitness
		end

	end


	def MaxOnes.create_individual(genome_size)
		individual = EvoSynth::Core::MaximizingIndividual.new
		individual.genome = EvoSynth::Core::ArrayGenome.new(genome_size)
		individual.genome.map! { rand(2) > 0 ? true : false }
		individual
	end


	profile = Struct.new(:individual, :mutation, :selection, :recombination, :population, :fitness_calculator).new
	profile.individual = MaxOnes.create_individual(10)
	profile.mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
#	profile.mutation = EvoSynth::Mutations::Identity.new
	profile.selection = EvoSynth::Selections::FitnessProportionalSelection.new
	profile.recombination = EvoSynth::Recombinations::KPointCrossover.new(2)
	profile.fitness_calculator = OnesCalculator.new
	base_population = EvoSynth::Core::Population.new(POP_SIZE) { MaxOnes.create_individual(10) }

	puts "using profile:"
	profile.each_pair { |key, value| puts "\t#{key} => #{value}" }
	puts

	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::Hillclimber, profile, POP_SIZE * GENERATIONS)
	puts profile.fitness_calculator
	puts

	profile.population = base_population.deep_clone
	profile.fitness_calculator.reset_counters
	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::PopulationHillclimber, profile, GENERATIONS)
	puts profile.fitness_calculator
	puts

	profile.population = base_population.deep_clone
	profile.fitness_calculator.reset_counters
	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::GeneticAlgorithm, profile, GENERATIONS)
	puts profile.fitness_calculator
	puts

	profile.population = base_population.deep_clone
	profile.fitness_calculator.reset_counters
	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::ElitismGeneticAlgorithm, profile, GENERATIONS)
	puts profile.fitness_calculator
	puts

	profile.population = base_population.deep_clone
	profile.fitness_calculator.reset_counters
	EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Algorithms::SteadyStateGA, profile, GENERATIONS)
	puts profile.fitness_calculator
end
