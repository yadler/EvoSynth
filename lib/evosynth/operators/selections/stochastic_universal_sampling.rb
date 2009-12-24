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

	module Selections

		#	STOCHASTISCHES-UNIVERSELLES-SAMPLING (Weicker Page 75)
		# FIXME: add RSPec (find testcase!)

		class StochasticUniversalSampling

			def select(population, select_count = 1)
				fitness_sum = 0.0
				population.each { |individual| fitness_sum += individual.fitness }

				limit = rand(fitness_sum / select_count)

				select_count.times do
					next_individual = select_next_individual(population, fitness_sum)
					selected_population.add(next_individual)
					limit += fitness_sum / select_count
				end
			end

			private

			def select_next_individual(population)
				selection_sum = 0.0
				population.each do |individual|
					selection_sum += individual.fitness
					return individual if (selection_sum >= limit)
				end
			end

		end
	end
end