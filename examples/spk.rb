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

class TrueClass
	def flip
		!self
	end
end

class FalseClass
	def flip
		!self
	end
end

module SPk

	class Individual
		include EvoSynth::MaximizingIndividual

		attr_accessor :genome

		def initialize(genome_size, k)
			@genome = EvoSynth::ArrayGenome.new(genome_size)
			@genome.map! { rand(2) > 0 ? true : false }

			@valid = false
			@k = k
			@muation_probability = 0.5
		end

		def calculate_fitness
			fitness = 0.0

			if is_valid
				fitness = @genome.size * (count_ones + 1)
			else
				fitness = @genome.size - count_ones
			end

			fitness
		end

		def to_s
			"#{fitness} \t #{@genome} \t #{is_valid ? 'valid' : 'invalid'} \t 1's = #{count_ones}"
		end

		private

		def count_ones
			ones = 0
			@genome.each { |gene| ones += 1 if gene }
			ones
		end

		def is_valid
			if @genome.changed
				len_of_ones = calc_length_of_ones
				max_k = (@genome.size.to_f / (3.0 * @k*@k).to_f).ceil

				if !len_of_ones.nil? && len_of_ones / @k <= max_k && len_of_ones % @k == 0
					@valid = true
				else
					@valid = false
				end
			end

			@valid
		end

		def calc_length_of_ones
			count, len_of_ones = 0, 0
			end_of_ones, end_of_zeros = false, false

			@genome.each do |gene|
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


	K = 2
	GENOME_SIZE = 16
	GOAL = 48
	MAX_GENERATIONS = 1000
	INDIVIDUALS = 25

	require 'benchmark'
	#require 'profile'

	def SPk.run_population_based_algorithm(algorithm_class, &condition)
		algorithm = algorithm_class.new( EvoSynth::Population.new(INDIVIDUALS) { SPk::Individual.new(GENOME_SIZE, K) } )
		result = algorithm.run_until(&condition)
		puts algorithm
		puts "\treached goal after #{algorithm.generations_run}"
		puts "\tbest individual: #{result.best}"
		puts "\tworst individual: #{result.worst}"
	end

	timing = Benchmark.measure do
		individual = SPk::Individual.new(GENOME_SIZE, K)
		hillclimber = EvoSynth::Algorithms::Hillclimber.new(individual)
		result = hillclimber.run_until_generations_reached(INDIVIDUALS * MAX_GENERATIONS)
		puts hillclimber
		puts "\treached goal after #{hillclimber.generations_run}"
		puts "\tbest: #{result}"

		puts
		SPk.run_population_based_algorithm(EvoSynth::Algorithms::PopulationHillclimber) { |gen| gen >= MAX_GENERATIONS}
		puts
		SPk.run_population_based_algorithm(EvoSynth::Algorithms::GeneticAlgorithm) { |gen, best| best.fitness >= GOAL || gen > MAX_GENERATIONS }
		puts
		SPk.run_population_based_algorithm(EvoSynth::Algorithms::ElitismGeneticAlgorithm) { |gen| gen >= MAX_GENERATIONS}
		puts
		SPk.run_population_based_algorithm(EvoSynth::Algorithms::SteadyStateGA) { |gen| gen >= MAX_GENERATIONS}
	end
	puts "\nRunning these algorithms took:\n#{timing}"

end