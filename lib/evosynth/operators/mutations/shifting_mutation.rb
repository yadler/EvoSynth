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

		# The ShiftingMutation shifts a random range of genes by one index in the genome. It is based on
		# VERSCHIEBENDE-MUTATION (Weicker 2007, page 132).
		# 
		# This mutations does not destroy permutations.

		class ShiftingMutation

			#Return a deep copy of this operator

			def deep_clone
				self.clone
			end

			#	:call-seq:
			#		mutate(Individual) -> Individual
			#
			# Returns a clone of a given individual and shifts a random range of
			# genes by one index in the genome of this clone.
			#
			#     m = ShiftingMutation.new
			#     m.mutate(a_individual)   #=> a_new_individual

			def mutate(individual)
				mutated = individual.deep_clone
				genome = mutated.genome

				index_one = EvoSynth.rand(genome.size)
				index_two = EvoSynth.rand(genome.size)
				return mutated if index_one == index_two

				shift_genome(index_one, index_two, genome)
				mutated
			end

			#	:call-seq:
			#		to_s -> string
			#
			# Returns description of this mutation
			#
			#     m = ShiftingMutation.new
			#     m.to_s                   #=> "shifting muation"

			def to_s
				"shifting muation"
			end

			private

			# this function does the actual shift (left and right)

			def shift_genome(index_one, index_two, genome)
				if index_one > index_two
					## shift right
					shifted_range = genome[index_two..index_one]
					shifted_range = shifted_range << shifted_range.shift
					genome[index_two..index_one] = shifted_range
				else
					## shift left
					shifted_range = genome[index_one..index_two]
					shifted_range = [shifted_range.pop] + shifted_range
					genome[index_one..index_two] = shifted_range
				end
			end
		end

	end
end