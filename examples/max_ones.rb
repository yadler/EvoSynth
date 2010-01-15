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


module MaxOnes

	class BinaryIndividual
		include EvoSynth::Core::MaximizingIndividual

		def initialize(genome_size)
			@genome = EvoSynth::Core::ArrayGenome.new(genome_size)
			@genome.map! { rand(2) > 0 ? true : false }
		end

		def calculate_fitness
			fitness = 0
			genome.each { |gene| fitness += 1 if gene }
			fitness
		end
	end


	def MaxOnes.run_algorithm(algorithm_class, profile, generations)
		algorithm = algorithm_class.new(profile)
		result = nil

		puts "Running #{algorithm}..."
		timing = Benchmark.measure { result = algorithm.run_until_generations_reached(generations) }

		puts "\treached goal after #{algorithm.generations_run}"
		puts "\tindividual: #{result}" if defined? result.calculate_fitness
		puts "\tbest individual: #{result.best}" if defined? result.best
		puts "\tworst individual: #{result.worst}" if defined? result.worst
		puts "\tRunning these algorithm took:\n\t\t#{timing}"
		puts
	end
end

POP_SIZE = 25
GENERATIONS = 1000

require 'benchmark'
#require 'profile'


profile = Struct.new(:individual, :mutation, :selection, :recombination, :population).new
profile.individual = MaxOnes::BinaryIndividual.new(10)
profile.mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
profile.selection = EvoSynth::Selections::FitnessProportionalSelection.new
profile.recombination = EvoSynth::Recombinations::KPointCrossover.new(2)
base_population = EvoSynth::Core::Population.new(POP_SIZE) { MaxOnes::BinaryIndividual.new(10) }
profile.population = base_population.deep_clone


puts "using profile:"
profile.each_pair { |key, value| puts "\t#{key} => #{value}" }
puts


MaxOnes.run_algorithm(EvoSynth::Algorithms::Hillclimber, profile, POP_SIZE * GENERATIONS)
MaxOnes.run_algorithm(EvoSynth::Algorithms::PopulationHillclimber, profile, GENERATIONS)
MaxOnes.run_algorithm(EvoSynth::Algorithms::GeneticAlgorithm, profile, GENERATIONS)
MaxOnes.run_algorithm(EvoSynth::Algorithms::ElitismGeneticAlgorithm, profile, GENERATIONS)
MaxOnes.run_algorithm(EvoSynth::Algorithms::SteadyStateGA, profile, GENERATIONS)
