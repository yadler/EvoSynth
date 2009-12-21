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

		# Q-STUFIGE-TURNIER-SELEKTION (Weicker Page 69)

		class NStageTournamentSelection

			attr_accessor :stages

			def initialize(stages = 2)
				@stages = stages
			end

			def select(population, select_count = 1)
				scores = []

				population.each do |individual|
					victories = 0

					@stages.times do
						enemy = population[rand(population.size)]
						victories += 1 if individual > enemy
					end

					scores << [victories, individual]
				end

				selected = Population.new
				scores.sort! { |a, b| a[0] <=> b[0] }
				scores.reverse!
				scores.first(select_count).each { |winner| selected.add(winner[1]) }
				selected
			end

		end

	end

end

