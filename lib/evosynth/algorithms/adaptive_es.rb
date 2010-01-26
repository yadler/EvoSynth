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
	module Algorithms

		# ES-ADAPTIV (Weicker Page 135)

		class AdaptiveES
			include EvoSynth::Algorithms::Algorithm

			attr_accessor :child_count
			attr_reader :sigma, :success

			DEFAULT_SIGMA = 0.1
			DEFAULT_CHILD_FACTOR = 5
			DEFAULT_MODIFICATION_FREQUENCY = 10
			DEFAULT_MUTATION = EvoSynth::Mutations::GaussMutation.new(DEFAULT_SIGMA)
			DEFAULT_PARENT_SELECTION = EvoSynth::Selections::RandomSelection.new
			DEFAULT_SELECTION = EvoSynth::Selections::SelectBest.new
			DEFAULT_ADJUSTMENT = EvoSynth::Adjustments::AdaptiveAdjustment.new

			def initialize(profile)
				init_profile :population, :fitness_calculator,
					:child_factor => DEFAULT_CHILD_FACTOR,
					:modification_frequency => DEFAULT_MODIFICATION_FREQUENCY,
				    :mutation => DEFAULT_MUTATION,
					:adjustment => DEFAULT_ADJUSTMENT,
				    :selection => DEFAULT_SELECTION,
				    :parent_selection => DEFAULT_PARENT_SELECTION

				use_profile profile
				@sigma = DEFAULT_SIGMA
				@success = 0

				@population.each { |individual| @fitness_calculator.calculate_and_set_fitness(individual) }
			end

			def to_s
				"adaptive ES <mutation: #{@mutation}, individual: #{@individual}>"
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
					@mutation.sigma = @sigma # FIXME: remove this strong dependency on GaussMutation
					child = @mutation.mutate(parent)

					@fitness_calculator.calculate_and_set_fitness(child)
#					puts child, parent
#					puts "..."
					@success += 1 if child > parent
					child_population << child
				end

				@population = @selection.select(child_population, @population.size)
				if @generations_computed % @modification_frequency == 0
					success_rate =  @success / (@modification_frequency - (@child_factor * @population.size))
					@sigma = @adjustment.adjust(@sigma, success_rate) # FIXME: remove this strong dependency on AdaptiveAdjustment
					@success = 0
				end
			end
		end

	end
end
