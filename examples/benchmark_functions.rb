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

	VALUE_BITS = 32
	DIMENSIONS = 6
	GENERATIONS = 10000

	class BenchmarkCalculator
		include EvoSynth::Core::FitnessCalculator

		def decode(individual)
			values = []
			DIMENSIONS.times { |dim| values << EvoSynth::Decoder.binary_to_real(individual.genome[dim * VALUE_BITS, VALUE_BITS], -5.12, 5.12) }
			values
		end

		def calculate_fitness(individual)
			EvoSynth::BenchmarkFuntions.sphere(decode(individual))
		end

	end


	def BenchmarkFunctionExample.create_individual(genome_size)
		individual = EvoSynth::Core::MinimizingIndividual.new
		individual.genome = EvoSynth::Core::ArrayGenome.new(genome_size)
		individual.genome.map! { rand(2) > 0 ? true : false }
		individual
	end


	profile = Struct.new(:individual, :mutation, :selection, :recombination, :population, :fitness_calculator).new
	profile.individual = BenchmarkFunctionExample.create_individual(VALUE_BITS*DIMENSIONS)
	profile.mutation = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
	profile.fitness_calculator = BenchmarkCalculator.new

	algorithm = EvoSynth::Algorithms::Hillclimber.new(profile)
	algorithm.add_observer(EvoSynth::Util::ConsoleWriter.new(1000))

	result = algorithm.run_until_generations_reached(GENERATIONS)

	puts result
	puts profile.fitness_calculator
end
