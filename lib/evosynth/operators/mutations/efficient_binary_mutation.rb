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

		# This mutation is basically a optimized version of the BinaryMutation and should have a better performance on long genomes.
		#
		# It flips each gene in the genome of a given individual using the given flip function (a lambda) with a given
		# probability and returns a mutated individual. To use this mutation the flip_function has to return the negation/inverse
		# of a given gene. This mutations is based on EFFIZIENTE-BINAERE-MUTATION (Weicker 2007, page 130).

		class EfficientBinaryMutation

			# Each gene is flipped with this probability (should be between 0 and 1)

			attr_accessor :probability

			# This function is used to flip each gene

			attr_accessor :flip_function

			# the default mutation probability

			DEFAULT_PROBABILITY = 0.1

			#	:call-seq:
			#		EfficientBinaryMutation.new(Lambda) -> EfficientBinaryMutation
			#		EfficientBinaryMutation.new(Lambda, Float) -> EfficientBinaryMutation (overrides default probability)
			#
			# Returns a new EfficientBinaryMutation. In the first form, the default mutation probability BinaryMutation::DEFAULT_PROBABILITY (0.1)
			# is used. In the second it creates a BinaryMutation with the given probability.
			#
			#     custom_flip_function = lambda { |gene| EvoSynth.rand(42 * gene) }
			#     EfficientBinaryMutation.new(custom_flip_function)
			#     EfficientBinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN, 0.01)

			def initialize(flip_function, probability = DEFAULT_PROBABILITY)
				@flip_function = flip_function
				@probability = probability
			end

			#Return a deep copy of this operator

			def deep_clone
				my_clone = self.clone
				my_clone.flip_function = @flip_function.clone
				my_clone
			end

			#	:call-seq:
			#		mutate(Individual) -> Individual
			#
			# Returns the mutation (with the given flip function) of a given individual.
			#
			#     m = EfficientBinaryMutation.new
			#     m.mutate(a_individual)   #=> a_new_individual

			def mutate(individual)
				mutated = individual.deep_clone
				@next_index = EvoSynth.rand(mutated.genome.size) unless defined? @next_index

				while @next_index < mutated.genome.size
					if @flip_function.arity == 1
						mutated.genome[@next_index] = @flip_function.call(mutated.genome[@next_index])
					else
						mutated.genome[@next_index] = @flip_function.call
					end
					
					@next_index += (Math.log(EvoSynth.rand) / Math.log(1 - @probability)).ceil
				end

				@next_index %= mutated.genome.size
				mutated
			end

			#	:call-seq:
			#		to_s -> string
			#
			# Returns description of this mutation
			#
			#     m = EfficientBinaryMutation.new(0.91)
			#     m.to_s                   #=> "efficient binary muation <probability: 0.01>"

			def to_s
				"efficient binary muation <probability: #{@probability}>"
			end

		end

	end
end