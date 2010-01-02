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
	module Mutations

		# EFFIZIENTE-BINÄRE-MUTATION (Seite 130)

		class EfficientBinaryMutation

			attr_accessor :probability

			def initialize(probability = 0.1)
				@probability = probability
			end


			def mutate(individual)
				mutated = individual.deep_clone
				@next_index = rand(mutated.genome.size) unless defined? @next_index

				while @next_index < mutated.genome.size
					mutated.genome[@next_index] = mutated.genome[@next_index].flip
					@next_index += (Math.log(rand) / Math.log(1 - @probability)).ceil
				end

				@next_index -= mutated.genome.size
				mutated
			end

			def to_s
				"efficient binary muation"
			end

		end

	end
end