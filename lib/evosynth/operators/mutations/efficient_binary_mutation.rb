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

		# EFFIZIENTE-BINAERE-MUTATION (Weicker page 130)
		# FIXME: documentation is outdated!
		# 
		# This mutation is basically a optimized version of the BinaryMutation and
		# should have a better performance on long genomes.
		#
		# <b>Relies on:</b> flip and deep_clone (see below)
		#
		# This mutations flips (inverts) each gene in the genome of a given individual
		# with a given probability and returns a mutated individual. It does not
		# change the given individual. To use this mutation each gene of the genome
		# must provide the <i>flip</i> function, which returns the negation/inverse of
		# its value. The given individual has to provide a <i>deep_clone</i> method,
		# which clones the individual and its genome.

		class EfficientBinaryMutation

			# Each gene is flipped with this probability (should be between 0 and 1)

			attr_accessor :probability

			# This function is used to flip each gene

			attr_accessor :flip_function

			DEFAULT_PROBABILITY = 0.1

			# FIXME: documentation is outdated!
			#	:call-seq:
			#		EfficientBinaryMutation.new
			#		EfficientBinaryMutation(Float) -> EfficientBinaryMutation (overrides default probability)
			#
			# Returns a new EfficientBinaryMutation. In the first form, the default mutation
			# probability (0.1) is used. In the second it creates a EfficientBinaryMutation with the given probability.
			#
			#     EfficientBinaryMutation.new
			#     EfficientBinaryMutation.new(0.01)

			def initialize(flip_function, probability = DEFAULT_PROBABILITY)
				@flip_function = flip_function
				@probability = probability
			end

			# FIXME: documentation is outdated!
			#	:call-seq:
			#		mutate(Individual) -> Individual
			#
			# Returns the mutation of a given individual.
			#
			#     m = EfficientBinaryMutation.new
			#     m.mutate(a_individual)   #=> a_new_individual

			def mutate(individual)
				mutated = individual.deep_clone
				@next_index = rand(mutated.genome.size) unless defined? @next_index

				while @next_index < mutated.genome.size
					mutated.genome[@next_index] = @flip_function.call(mutated.genome[@next_index])
					@next_index += (Math.log(rand) / Math.log(1 - @probability)).ceil
				end

				@next_index -= mutated.genome.size
				mutated
			end

			# FIXME: documentation is outdated!
			#	:call-seq:
			#		mutation.to_s -> string
			#
			# Returns description of this mutation
			#
			#     m = BinaryMutation.new(0.91)
			#     m.to_s                   #=> "efficient binary muation <probability: 0.01>"

			def to_s
				"efficient binary muation <probability: #{@probability}>"
			end

		end

	end
end