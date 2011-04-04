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

		# GLEICHVERTEILTE-REELWERTIGE-MUTATION (Weicker page 131)
		# TODO: needs rdoc

		class UniformRealMutation

			DEFAULT_PROBABILITY = 0.1
			DEFAULT_STEP_SIZE = 0.1

			def initialize(probability = DEFAULT_PROBABILITY, step_size = DEFAULT_STEP_SIZE)
				@probability = probability
				@step_size = step_size
			end

			#Return a deep copy of this operator

			def deep_clone
				self.clone
			end

			def mutate(individual)
				mutated = individual.deep_clone
				genome = mutated.genome

				genome.size.times do |index|
					genome[index] += @step_size - 2 * EvoSynth.rand * @step_size if EvoSynth.rand <= @probability
				end

				mutated
			end

			def to_s
				"uniform real mutation <probability: #{@probability}>"
			end

		end

	end
end