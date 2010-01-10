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


		module Algorithm

			attr_reader :generations_run

			def run_until(&condition)
				@generations_run = 0

				case condition.arity
					when 1
						loop_condition = lambda { !yield @generations_run }
					when 2
						loop_condition = lambda { !yield @generations_run, best_solution }
				else
					loop_condition = nil
				end

				while loop_condition.call
					next_generation
					@generations_run += 1
				end

				return_result
			end

			def run_until_generations_reached(max_generations)
				run_until { |gen| gen == max_generations }
			end

			def run_until_fitness_reached(fitness)
				goal = Goal.new(fitness)
				run_until { |gen, best| best > goal }
			end

			private

			class Goal
				def initialize(goal)
					@goal = goal
				end

				def fitness
					@goal
				end
			end

		end


	end
end

require 'evosynth/algorithms/hillclimber'
require 'evosynth/algorithms/population_hillclimber'
require 'evosynth/algorithms/genetic_algorithm'
require 'evosynth/algorithms/steady_state_ga'
