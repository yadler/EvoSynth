#    Copyright (C) 2009 Yves Adler <yves.adler@googlemail.com>
#
#    This file is part of EvoSynth, a framework for rapid prototyping of
#    evolutionary and genetic algorithms.
#
#    EvoSynth is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    EvoSynth is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with EvoSynth.  If not, see <http://www.gnu.org/licenses/>.

# Author::    Yves Adler (mailto:yves.adler@googlemail.com)
# Copyright:: Copyright (C) 2009 Yves Adler
# License::   LGPLv3


require 'delegate'

module EvoSynth
	module Algorithms


		module Algorithm

			attr_reader :generations_run

			def run_until(&condition)
				@generations_run = 0

				case condition.arity
					when 1
						loop_condition = lambda { !condition.call @generations_run }
					when 2
						loop_condition = lambda { !condition.call @generations_run, best_solution }
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
				run_until { |gen, best| best.fitness >= fitness }
			end

		end


	end
end

require 'evosynth/algorithms/hillclimber'
require 'evosynth/algorithms/population_hillclimber'
require 'evosynth/algorithms/genetic_algorithm'
require 'evosynth/algorithms/steady_state_ga'
