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
			              :recombination_probability, :population

			def initialize(population, recombination_probability = 0.75)
				@population = population
				@recombination_probability = recombination_probability

				@selection = EvoSynth::Selections::FitnessProportionalSelection.new
				@recombination = EvoSynth::Recombinations::OnePointCrossover.new
				@mutation = EvoSynth::Mutations::BinaryMutation.new(0.01)
			end

			def to_s
				"basic genetic algoritm <mutation: #{@mutation}, selection: #{@selection}, recombination: #{@recombination}>"
			end

			private

			def best_solution
				@population.best
			end

			def return_result
				@population
			end

			def next_generation
				selected_pop = @selection.select(@population, @population.size/2)
				@population.clear_all

				selected_pop.individuals.each_index do |index_one|
					# TODO: this could be avoided by #cycle which is introduced by 1.9
					index_two = index_one + 1
					index_two = -1 if index_two >= selected_pop.size

					if rand < @recombination_probability
						child_one, child_two = @recombination.recombine(selected_pop[index_one], selected_pop[index_two])
					else
						child_one = selected_pop[index_one]
						child_two = selected_pop[index_two]
					end

					@population.add(@mutation.mutate(child_one))
					@population.add(@mutation.mutate(child_two))
				end
			end

		end

	end
end