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
	module Evolvers

		# GENETISCHER-ALGORITHMUS (Weicker Page 85)

		class GeneticAlgorithm < EvoSynth::Evolver

			DEFAULT_SELECTION = EvoSynth::Selections::FitnessProportionalSelection.new
			DEFAULT_RECOMBINATION = EvoSynth::Recombinations::OnePointCrossover.new
			DEFAULT_RECOMBINATION_PROBABILITY = 0.75
			DEFAULT_CHILD_FACTOR = 0.5

			def required_parameters?
				{
					:population					=> REQUIRED_PARAMETER,
				    :evaluator					=> REQUIRED_PARAMETER,
				    :mutation					=> REQUIRED_PARAMETER,
				    :parent_selection			=> DEFAULT_SELECTION,
				    :recombination				=> DEFAULT_RECOMBINATION,
				    :recombination_probability	=> DEFAULT_RECOMBINATION_PROBABILITY,
					:child_factor				=> DEFAULT_CHILD_FACTOR
				}
			end

			def setup!
				@population.each { |individual| @evaluator.calculate_and_set_initial_fitness(individual) }
			end

			def to_s
				"basic genetic algoritm <mutation: #{@mutation}, parent selection: #{@parent_selection}, recombination: #{@recombination}>"
			end

			def best_solution?
				@population.best
			end

			def worst_solution?
				@population.worst
			end

			def result?
				@population
			end

			def next_generation!
				selected_pop = @parent_selection.select(@population, @population.size * @child_factor)
				@population.clear

				selected_pop.each_index do |index_one|
					index_two = (index_one + 1) % selected_pop.size

					if EvoSynth.rand < @recombination_probability
						child_one, child_two = @recombination.recombine(selected_pop[index_one], selected_pop[index_two])
					else
						child_one = selected_pop[index_one]
						child_two = selected_pop[index_two]
					end

					@population.add(@mutation.mutate(child_one))
					@population.add(@mutation.mutate(child_two))
				end

				@population.each { |individual| @evaluator.calculate_and_set_fitness(individual) }
			end

		end

	end
end