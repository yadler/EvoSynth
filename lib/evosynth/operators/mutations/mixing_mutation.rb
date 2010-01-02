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

		# MISCHENDE-MUTATION (Seite 132)

		class MixingMutation

			def mutate(individual)
				mutated = individual.deep_clone
				genome = mutated.genome

				index_one = rand(genome.size)
				index_two = rand(genome.size)
				index_one, index_two = index_two, index_one if index_one > index_two
				return mutated if index_one == index_two

				subsection = genome[index_one, index_two]
				subsection.sort! { rand(3) - 1 }
				subsection.each_index { |index| genome[index_one + index] = subsection[index] }

				mutated
			end

			def to_s
				"mixing muation"
			end

		end

	end
end