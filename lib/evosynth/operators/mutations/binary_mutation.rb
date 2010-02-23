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

		# This mutations flips each gene in the genome of a given individual using the given flip function (a lambda) with a given
		# probability and returns a mutated individual. To use this mutation the flip_function has to return the negation/inverse
		# of a given gene. This mutations is based on BINAERE-MUTATION (Weicker 2007, page 59).

		class BinaryMutation

			# Each gene is flipped with this probability (should be between 0 and 1)

			attr_accessor :probability

			# This function (lambda) is used to flip each gene

			attr_accessor :flip_function

			# the default mutation probability

			DEFAULT_PROBABILITY = 0.1

			#	:call-seq:
			#		BinaryMutation.new(Lambda) -> BinaryMutation
			#		BinaryMutation.new(Lambda, Float) -> BinaryMutation (overrides default probability)
			#
			# Returns a new BinaryMutation. In the first form, the default mutation probability BinaryMutation::DEFAULT_PROBABILITY (0.1)
			# is used. In the second it creates a BinaryMutation with the given probability.
			#
			#     custom_flip_function = lambda { |gene| EvoSynth.rand(42 * gene) }
			#     BinaryMutation.new(custom_flip_function)
			#     BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN, 0.01)

			def initialize(flip_function, probability = DEFAULT_PROBABILITY)
				@flip_function = flip_function
				@probability = probability
			end

			#	:call-seq:
			#		mutate(Individual) -> Individual
			#
			# Returns the mutation (with the given flip function) of a given individual.
			#
			#     m = BinaryMutation.new
			#     m.mutate(a_individual)   #=> a_new_individual

			def mutate(individual)
				mutated = individual.deep_clone
				genome = mutated.genome

				genome.size.times do |index|
					if @flip_function.arity == 1
						genome[index] = @flip_function.call(genome[index]) if EvoSynth.rand <= @probability
					else
						genome[index] = @flip_function.call if EvoSynth.rand <= @probability
					end
				end

				mutated
			end

			#	:call-seq:
			#		to_s -> string
			#
			# Returns description of this mutation
			#
			#     m = BinaryMutation.new(0.01)
			#     m.to_s                   #=> "binary mutation <probability: 0.01>"

			def to_s
				"binary mutation <probability: #{@probability}>"
			end

		end

	end
end