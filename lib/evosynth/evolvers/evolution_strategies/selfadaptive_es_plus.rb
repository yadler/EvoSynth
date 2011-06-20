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

		# ES-SELBSTADAPTIV (Weicker Page 135)

		class SelfAdaptiveES < EvoSynth::Evolver

			DEFAULT_CHILD_FACTOR = 5
			DEFAULT_MUTATION = EvoSynth::Mutations::SelfAdaptiveGaussMutation.new
			DEFAULT_PARENT_SELECTION = EvoSynth::Selections::RandomSelection.new
			DEFAULT_ENV_SELECTION = EvoSynth::Selections::SelectBest.new

			def required_parameters?
				{
					:population				=> REQUIRED_PARAMETER,
				    :evaluator				=> REQUIRED_PARAMETER,
				    :child_factor			=> DEFAULT_CHILD_FACTOR,
				    :mutation				=> DEFAULT_MUTATION,
				    :enviromental_selection => DEFAULT_ENV_SELECTION,
				    :parent_selection		=> DEFAULT_PARENT_SELECTION
				}
			end

			def setup!
				@population.each { |individual| @evaluator.calculate_and_set_initial_fitness(individual) }
			end

			def to_s
				"selfadaptive ES <mutation: #{@mutation}, parent selection: #{@parent_selection}, parent selection: #{@parent_selection}, enviromental selection: #{@enviromental_selection}>"
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
				child_population = @population.deep_clone

				(@child_factor * @population.size).times do
					parent = @parent_selection.select(@population, 1).first
					child = @mutation.mutate(parent)
					@evaluator.calculate_and_set_fitness(child)
					child_population << child
				end

				@population = @enviromental_selection.select(child_population, @population.size)
			end
		end

	end
end
