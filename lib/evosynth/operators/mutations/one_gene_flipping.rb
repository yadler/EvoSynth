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

		# EIN-BIT-BINAERE-MUTATION (Weicker page 48)
		#
		# FIXME: documentation is outdated!
		# 
		# This mutations flips (inverts) one gene in the genome of a given individual
		# and returns this mutated individual. It does not change the given individual
		# 
		# To use this mutation each gene of the genome has to support the "flip"
		# function as negation/inverse of its value
		#
		# The given individual has to provide a deep_clone method

		class OneGeneFlipping

			# This function is used to flip each gene

			attr_accessor :flip_function

			def initialize(flip_function)
				@flip_function = flip_function
			end

			def mutate(individual)
				mutated = individual.deep_clone
				genome = mutated.genome

				rand_index = rand(genome.size)
				if @flip_function.arity == 1
					genome[rand_index] = @flip_function.call(genome[rand_index])
				else
					genome[rand_index] = @flip_function.call
				end

				mutated
			end

			def to_s
				"one-gene-flipping"
			end

		end

	end

end