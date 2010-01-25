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

		# GAUSS-MUTATION (Weicker page 60)

		class GaussMutation

			DEFAULT_SIGMA = 1.0

			def initialize(sigma = DEFAULT_SIGMA, lower_bound = Float::MIN, upper_bound = Float::MAX)
				@sigma = sigma
				@precalculated_part_one = 1.0 / (Math.sqrt(2 * Math::PI) * @sigma)
				@pre_calculated_part_two = -1.0 / (2 * @sigma**2)
				@lower_bound = lower_bound
				@upper_bound = upper_bound
			end

			def mutate(individual)
				mutated = individual.deep_clone

				mutated.genome.map! do |gene|
					gene += rand * density_function(gene) - density_function(gene)/2
					gene = @lower_bound if gene < @lower_bound
					gene = @upper_bound if gene > @upper_bound
					gene
				end

				mutated
			end

			def to_s
				"identity (just clones individual)"
			end

			private

			def density_function(x)
				@precalculated_part_one * Math.exp(@pre_calculated_part_two * x**2)
			end
		end

	end
end