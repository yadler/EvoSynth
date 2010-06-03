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

		# ES-ADAPTIV (Weicker Page 135)
		# 
		# TODO: rdoc (mutation and adjustment are fixed!)

		class AdaptiveES < EvoSynth::Evolvers::Evolver

			attr_reader :success

			DEFAULT_SIGMA = 0.1
			DEFAULT_CHILD_FACTOR = 5
			DEFAULT_MODIFICATION_FREQUENCY = 10
			DEFAULT_MUTATION = EvoSynth::Mutations::GaussMutation.new(DEFAULT_SIGMA)
			DEFAULT_PARENT_SELECTION = EvoSynth::Selections::RandomSelection.new
			DEFAULT_ENV_SELECTION = EvoSynth::Selections::SelectBest.new
			DEFAULT_ADJUSTMENT = EvoSynth::Adjustments::AdaptiveAdjustment.new

			def required_configuration?
				{
					:population				=> REQUIRED_FIELD,
				    :evaluator				=> REQUIRED_FIELD,
				    :sigma					=> DEFAULT_SIGMA,
				    :child_factor			=> DEFAULT_CHILD_FACTOR,
				    :modification_frequency => DEFAULT_MODIFICATION_FREQUENCY,
				    :enviromental_selection => DEFAULT_ENV_SELECTION,
				    :parent_selection		=> DEFAULT_PARENT_SELECTION
				}
			end

			def setup
				@adjustment = DEFAULT_ADJUSTMENT
				@mutation = DEFAULT_MUTATION
				@success = 0
				@population.each { |individual| @evaluator.calculate_and_set_initial_fitness(individual) }
			end

			def to_s
				"adaptive ES <sigma: #{@sigma}, success: #{@success}, mutation: #{@mutation}, parent selection: #{@parent_selection}, enviromental selection: #{@enviromental_selection}>"
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
				child_population = EvoSynth::Population.new

				(@child_factor * @population.size).times do
					parent = @parent_selection.select(@population, 1).first
					@mutation.sigma = @sigma
					child = @mutation.mutate(parent)
 
					@evaluator.calculate_and_set_fitness(child)
					@success += 1 if child > parent
					child_population << child
				end

				@population = @enviromental_selection.select(child_population, @population.size)
				if @generations_computed % @modification_frequency == 0
					success_rate =  @success / (@modification_frequency - (@child_factor * @population.size))
					@sigma = @adjustment.adjust(@sigma, success_rate)
					@success = 0
				end
			end
		end

	end
end
