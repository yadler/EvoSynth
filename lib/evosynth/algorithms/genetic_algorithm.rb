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


module EvoSynth
	module Algorithms

		# GENETISCHER-ALGORITHMUS (Weicker Page 85)

		class GeneticAlgorithm
			include EvoSynth::Algorithms::Algorithm

			attr_accessor :mutation, :selection, :recombination,
			              :recombination_probability, :population,
						  :fitness_calculator

			def initialize(profile)
				@population = profile.population
				@selection = profile.selection
				@recombination = profile.recombination
				@mutation = profile.mutation
				@fitness_calculator = profile.fitness_calculator

				if defined? profile.recombination_probability
					@recombination_probability = profile.recombination_probability
				else
					@recombination_probability = 0.75
				end

				@population.each { |individual| @fitness_calculator.calculate_and_set_fitness(individual) }
			end

			def to_s
				"basic genetic algoritm <mutation: #{@mutation}, selection: #{@selection}, recombination: #{@recombination}>"
			end

			def best_solution
				@population.best
			end

			def worst_solution
				@population.worst
			end

			private

			def return_result
				@population
			end

			def next_generation
				selected_pop = @selection.select(@population, @population.size/2)
				@population.clear

				selected_pop.each_index do |index_one|
					index_two = (index_one + 1) % selected_pop.size

					if rand < @recombination_probability
						child_one, child_two = @recombination.recombine(selected_pop[index_one], selected_pop[index_two])
					else
						child_one = selected_pop[index_one]
						child_two = selected_pop[index_two]
					end

					@population.add(@mutation.mutate(child_one))
					@population.add(@mutation.mutate(child_two))
				end

				@population.each { |individual| @fitness_calculator.calculate_and_set_fitness(individual) }
			end

		end

	end
end