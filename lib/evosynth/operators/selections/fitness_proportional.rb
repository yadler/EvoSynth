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

		# FIXME needs proper tests

		def Selections.fitness_proportional_selection(population, select_count = 1)
			selected_population = Population.new()

			fitness_sum = 0
			population.each { |individual| fitness_sum += individual.fitness }

			select_count.times do |index|
				selection_sum = 1
				limit = rand(fitness_sum)

				population.each do |individual|
					selection_sum += individual.fitness
					if (selection_sum >= limit)
						selected_population.add(individual)
						break
					end
				end
			end

			selected_population
		end

	end

end