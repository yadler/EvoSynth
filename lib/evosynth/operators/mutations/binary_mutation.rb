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

		# <b>Relies on:</b> flip (see below)
		#
		# This mutations flips (inverts) each gene in the genome of a given individual
		# with a given probability  and returns this mutated individual. It does not
		# change the given individual
		#
		# To use this mutation each gene of the genome has to support the "flip"
		# function as negation/inverse of its value
		#
		# The given individual has to provide a deep_clone method

		class BinaryMutation

			# Each gene is flipped with this probability (should be between 0 and 1)

			attr_accessor :probability

			#	:call-seq:
			#		new -> BinaryMutation
			#		new(Float) -> BinaryMutation (overrides default probability)
			#
			# Creates a new BinaryMutation. The default mutation
			# probability is 0.1

			def initialize(probability = 0.1)
				@probability = probability
			end

			#	:call-seq:
			#		mutate(Individual) -> Individual
			#
			# Returns the mutation of the given individual.

			def mutate(individual)
				mutated = individual.deep_clone
				flip_genes(mutated.genome)

				mutated
			end

			# flips the genes only and only if it is really needed
			# NOTE: this might not be as pretty as .map! but its faster

			def flip_genes(genome)
				genome.size.times do |index|
					genome[index] = genome[index].flip if rand <= @probability
				end
			end

		end

	end
end