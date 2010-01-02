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
# Copyright:: Copyright (C) 2010 Yves Adler
# License::   LGPLv3


module EvoSynth
	module Mutations

		# VERSCHIEBENDE-MUTATION (Seite 132)

		class ShiftingMutation

			def mutate(individual)
				mutated = individual.deep_clone
				genome = mutated.genome

				index_one = rand(genome.size)
				index_two = rand(genome.size)
				return mutated if index_one == index_two

				genome[index_two] = genome[index_one]
				if index_one > index_two
					index_two.upto(index_one - 1) { |index| genome[index + 1] = individual.genome[index] }
				else
					(index_one + 1).upto(index_two) { |index| genome[index - 1] = individual.genome[index] }
				end

				mutated
			end

			def to_s
				"shifting muation"
			end

		end

	end
end