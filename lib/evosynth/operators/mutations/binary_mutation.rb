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


		# This mutations flips (inverts) each gene in the genome of a given individual
		# with a give probability  and returns this mutated individual. It does not
		# change the given individual
		#
		# To use this mutation each gene of the genome has to support the "!"
		# function as negation/inverse of its value
		#
		# The given individual has to provide a deep_clone method

		def Mutations.binary_mutation(individual, probability)
			mutated = individual.deep_clone
			mutated.genome.collect! { |gene| rand <= probability ? !gene : gene }
			mutated
		end

	end

end