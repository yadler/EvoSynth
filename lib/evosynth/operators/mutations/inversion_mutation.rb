#	Copyright (c) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
#
#	Permission is hereby granted, free of charge, to any person
#	obtaining a copy of this software and associated documentation
#	files (the "Software"), to deal in the Software without
#	restriction, including without limitation the rights to use,
#	copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the
#	Software is furnished to do so, subject to the following
#	conditions:
#
#	The above copyright notice and this permission notice shall be
#	included in all copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#	OTHER DEALINGS IN THE SOFTWARE.


module EvoSynth
	module Mutations

		# The InversionMutation inverts the order of a random range of genes in the genome. It is based on
		# INVERTIERENDE-MUTATION (Weicker 2007, page 28).
		# 
		# This mutations does not destroy permutations.

		class InversionMutation

			#	:call-seq:
			#		mutate(Individual) -> Individual
			#
			# Returns a clone of a given individual and inverts the order of a
			# random range of genes in the genome of this clone.
			#
			#     m = InversionMutation.new
			#     m.mutate(a_individual)   #=> a_new_individual

			def mutate(individual)
				mutated = individual.deep_clone
				genome = mutated.genome

				index_one = EvoSynth.rand(genome.size)
				index_two = EvoSynth.rand(genome.size)
				index_two = EvoSynth.rand(genome.size) while index_two == index_one
				index_one, index_two = index_two, index_one if index_one > index_two

				genome[index_one..index_two] = genome[index_one..index_two].reverse

				mutated
			end

			#	:call-seq:
			#		to_s -> string
			#
			# Returns description of this mutation
			#
			#     m = Identity.new
			#     m.to_s                   #=> "exchange mutation"

			def to_s
				"inversion mutation"
			end

		end

	end
end