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


module EvoSynth
	module Evolvers

		# DERANDOMISIERTE-ES (Weicker Page 139)
		#
		# TODO: rdoc

		class DerandomizedES
			include EvoSynth::Evolvers::Evolver

			attr_reader :s

			DEFAULT_SIGMA = 0.1
			DEFAULT_ALPHA = 0.2
			DEFAULT_TAU = 4		# Math.sqrt(genome.size) is a common value
			DEFAULT_CHILD_FACTOR = 5
			DEFAULT_MUTATION = EvoSynth::Mutations::GaussMutation.new(DEFAULT_SIGMA)
			DEFAULT_RECOMBINATION = EvoSynth::GlobalRecombinations::GlobalArithmeticCrossover.new
			DEFAULT_ENV_SELECTION = EvoSynth::Selections::SelectBest.new

			def initialize(profile)
				init_profile :population,
				    :evaluator,
					:sigma => DEFAULT_SIGMA,
					:alpha => DEFAULT_ALPHA,
					:tau => DEFAULT_TAU,
				    :child_factor => DEFAULT_CHILD_FACTOR,
				    :enviromental_selection => DEFAULT_ENV_SELECTION

				use_profile profile
				@mutation = DEFAULT_MUTATION
				@recombination = DEFAULT_RECOMBINATION

				genome_length = 0;
				@population.each do |individual|
					@evaluator.calculate_and_set_fitness(individual)
					genome_length = individual.genome.size if individual.genome.size > genome_length
				end
				@s = [0.0] * genome_length
			end

			def to_s
				"derandomized ES <sigma: #{@sigma}, success: #{@success}, mutation: #{@mutation}, parent selection: #{@parent_selection}, enviromental selection: #{@enviromental_selection}>"
			end

			def best_solution
				@population.best
			end

			def worst_solution
				@population.worst
			end

			def return_result
				@population
			end

			def next_generation
				z = []
				child_population = EvoSynth::Population.new
				child = @recombination.recombine(@population)

				(@child_factor * @population.size).times do
					mutated_child = @mutation.mutate(child)
					child_population << mutated_child

					z = []
					mutated_child.genome.each_with_index { |gene, index| z << gene - child.genome[index] }
				end

				child_population.each { |individual| @evaluator.calculate_and_set_fitness(individual) }
				@population = @enviromental_selection.select(child_population, @population.size)

				adjust_parameters(z)
			end

			private

			def adjust_parameters(z)
				# TODO: rename z and z_strich to something better
				z_strich = 1.0 / @population.size * z.inject(0.0) { |sum, index| sum += index }

				add_to_s = Math.sqrt(@alpha * (2 - @alpha) * @population.size) * z_strich
				@s.each_index { |index|	@s[index] = (1 - @alpha) * @s[index] + add_to_s }

				length_of_s = Math.sqrt( @s.inject(0.0) { |sum_of_pows, num| sum_of_pows += num**2 } )
				@sigma = @sigma * Math.exp( (length_of_s**2 - @s.size) / (2 * @tau * @s.size))
			end

		end

	end
end
