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
		# FIXME: the whole density function stuff is pretty unclear
		# TODO: needs rdoc

		class SelfAdaptiveGaussMutation
			attr_accessor :sigma, :lower_bound, :upper_bound

			DEFAULT_SIGMA = 1.0

			def initialize(sigma = DEFAULT_SIGMA, lower_bound = Float::MIN, upper_bound = Float::MAX)
				@sigma = sigma
				@lower_bound = lower_bound
				@upper_bound = upper_bound
				@gauss_distributed_0 = density_function(0, 1.0)
			end

			def mutate(individual)
				add_sigma(individual) unless defined? individual.sigma

				mutated = individual.deep_clone
				uniform_rand = rand * @gauss_distributed_0
				mutated.sigma = individual.sigma * Math.exp((1 / Math.sqrt(individual.genome.size)) * uniform_rand)

				mutated.genome.map! do |gene|
					gene += rand * density_function(gene, mutated.sigma)
					gene = @lower_bound if gene < @lower_bound
					gene = @upper_bound if gene > @upper_bound
					gene
				end

				mutated
			end

			def to_s
				"gauss mutation <sigma: #{@sigma}, lower bound: #{@lower_bound}, upper_bound: #{@upper_bound}>"
			end

			def add_sigma(individual)
#				individual.class.send(:attr_accessor, :sigma)
				individual.instance_eval("def sigma; @sigma end; def sigma=(value); @sigma = value end")
				individual.sigma = DEFAULT_SIGMA
			end

			def density_function(x, sigma)
				1.0 / (Math.sqrt(2 * Math::PI) * sigma) * Math.exp(-1.0 / (2 * sigma**2) * x**2)
			end

		end

	end
end