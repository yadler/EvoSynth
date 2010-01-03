#    Copyright (C) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
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


module EvoSynth
	module Recombinations

		# EIN-PUNKT-CROSSOVER (Weicker Page 84)

		class OnePointCrossover

			def recombine(parent_one, parent_two)
				child_one = parent_one.deep_clone
				child_two = parent_two.deep_clone

				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(parent_one, parent_two)
				crossover_point = rand(shorter.genome.size)

				first_range = 0..crossover_point
				child_one.genome[first_range] =  parent_one.genome[first_range]
				child_two.genome[first_range] =  parent_two.genome[first_range]

				second_range = (crossover_point + 1)..(shorter.genome.size - 1)
				child_one.genome[second_range] = parent_two.genome[second_range]
				child_two.genome[second_range] = parent_one.genome[second_range]

				[child_one, child_two]
			end

			def to_s
				"one-point crossover"
			end

		end

	end
end
