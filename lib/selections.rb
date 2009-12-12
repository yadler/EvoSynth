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

require 'population'

module EvoSynth

	module Selections


		def Selections.select_best(population, count = 0)
			population.sort!
			population[0..count]
		end


		def Selections.select_turnier(population, child_count = 1, enemies = 2)
			child_population = Population.new()

			child_count.times do
				individual = population[rand(population.size)]

				enemies.times do
					enemy = population[rand(population.size)]
					individual = enemy if enemy < individual
				end

				child_population.add(individual)
			end

			child_population.sort![0..child_count]
		end


	end

end

