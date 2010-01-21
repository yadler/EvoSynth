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

		# CCGA-1 (Mitchell A. Potter and Kenneth A. De Jong)

		class CCGA1
			include EvoSynth::Algorithms::Algorithm


			def initialize(profile)
				set_profile :mutation, :selection, :recombination, :populations, :fitness_calculator, :recombination_probability => 0.75
				use_profile profile

				@populations.each do |sub_population|
					sub_population.each { |individual| @fitness_calculator.calculate_and_set_fitness(individual) }
				end

				@next_index = 0
			end

			def to_s
				"CCGA-1 <mutation: #{@mutation}, selection: #{@selection}, recombination: #{@recombination}>"
			end

			def best_solution
				best = []
				@populations.each { |pop| best << pop.best.fitness }
				best.to_s
			end

			def worst_solution
				worst = []
				@populations.each { |pop| worst << pop.worst.fitness }
				worst.to_s
			end

			private

			def return_result
				best = []
				@populations.each { |pop| best << pop.best.fitness }
				best
			end

			def next_generation
				sub_population = @populations[@next_index]
				best_individual = sub_population.best

				selected_pop = @selection.select(sub_population, sub_population.size/2)
				sub_population.clear

				selected_pop.each_index do |index_one|
					index_two = (index_one + 1) % selected_pop.size

					if rand < @recombination_probability
						child_one, child_two = @recombination.recombine(selected_pop[index_one], selected_pop[index_two])
					else
						child_one = selected_pop[index_one]
						child_two = selected_pop[index_two]
					end

					sub_population.add(@mutation.mutate(child_one))
					sub_population.add(@mutation.mutate(child_two))
				end

				sub_population.each { |individual| @fitness_calculator.calculate_and_set_fitness(individual) }
				sub_population.remove(sub_population.worst)
				sub_population.add(best_individual)

				@next_index = (@next_index + 1) % @populations.size
			end

		end

	end
end