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

		# TURNIER-SELEKTION (Weicker Page 76)

		class TournamentSelection

			attr_accessor :enemies

			def initialize(enemies = 2)
				@enemies = enemies
			end


			def select(population, select_count = 1)
				selected_population = Population.new

				select_count.times do
					individual = population[rand(population.size)]

					@enemies.times do
						enemy = population[rand(population.size)]
						individual = enemy if enemy > individual
					end

					selected_population.add(individual)
				end

				selected_population
			end

		end

	end

end