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

		# SELBSTADAPTIVE-GAUSS-MUTATION (Weicker page 114)
		#
		# TODO: needs rdoc

		class SelfAdaptiveGaussMutation
			attr_accessor :initial_sigma, :lower_bound, :upper_bound

			DEFAULT_INITIAL_SIGMA = 1.0
			DEFAULT_LOWER_BOUND = -1 * Float::MAX
			DEFAULT_UPPER_BOUND = Float::MAX

			def initialize(initial_sigma = DEFAULT_INITIAL_SIGMA, lower_bound = DEFAULT_LOWER_BOUND, upper_bound = DEFAULT_UPPER_BOUND)
				@initial_sigma = initial_sigma
				@lower_bound = lower_bound
				@upper_bound = upper_bound
			end

			def mutate(individual)
				mutated = individual.deep_clone
				add_sigma(mutated) unless defined? mutated.sigma

				mutated.sigma *= Math.exp( (1 / Math.sqrt(mutated.genome.size)) * EvoSynth.nrand)

				mutated.genome.map! do |gene|
					gene += EvoSynth.nrand(0.0, mutated.sigma)
					gene = @lower_bound if gene < @lower_bound
					gene = @upper_bound if gene > @upper_bound
					gene
				end

				mutated
			end

			def to_s
				"self adaptive gauss mutation <sigma: #{@sigma}, lower bound: #{@lower_bound}, upper_bound: #{@upper_bound}>"
			end

			def add_sigma(individual)
				individual.instance_eval("def sigma; @sigma end; def sigma=(value); @sigma = value end")
				individual.sigma = @initial_sigma
			end

		end

	end
end