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


module EvoSynth
	module Algorithms

		# This is used by the #run_until_fitness_reached functions

		module EA_Algorithm

			attr_reader :generations_run

			def run(generations)
				@generations_run = 0

				generations.times do |gen|
					next_generation
					@generations_run = gen
				end

				return_result
			end

			def run_until_fitness_reached(fitness)
				@generations_run = 0
				goal = Goal.new(fitness)

				while best_solution < goal do
					next_generation
					@generations_run += 1
				end

				return_result
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