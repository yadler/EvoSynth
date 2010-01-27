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

		# ES-SELBSTADAPTIV (Weicker Page 135)

		class SelfAdaptiveES
			include EvoSynth::Algorithms::Algorithm

			attr_accessor :child_count

			DEFAULT_CHILD_FACTOR = 5
			DEFAULT_MUTATION = EvoSynth::Mutations::SelfAdaptiveGaussMutation.new
			DEFAULT_PARENT_SELECTION = EvoSynth::Selections::RandomSelection.new
			DEFAULT_SELECTION = EvoSynth::Selections::SelectBest.new
			DEFAULT_ADJUSTMENT = EvoSynth::Adjustments::AdaptiveAdjustment.new

			def initialize(profile)
				init_profile :population,
				    :fitness_calculator,
				    :child_factor => DEFAULT_CHILD_FACTOR,
				    :mutation => DEFAULT_MUTATION,
				    :adjustment => DEFAULT_ADJUSTMENT,
				    :selection => DEFAULT_SELECTION,
				    :parent_selection => DEFAULT_PARENT_SELECTION

				use_profile profile

				@population.each { |individual| @fitness_calculator.calculate_and_set_fitness(individual) }
			end

			def to_s
				"selfadaptive ES <mutation: #{@mutation}, parent selection: #{@parent_selection}, selection: #{@selection}>"
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
				child_population = EvoSynth::Core::Population.new

				(@child_factor * @population.size).times do
					parent = @parent_selection.select(@population, 1).first
					child = @mutation.mutate(parent)
					@fitness_calculator.calculate_and_set_fitness(child)
					child_population << child
				end

				@population = @selection.select(child_population, @population.size)
			end
		end

	end
end
