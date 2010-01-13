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
	module Recombinations

		# ARITHMETISCHER-CROSSOVER (Weicker page 83)

		# ATTENTION PLEASE! needs interpolation method to work:
		#  interpolation_method.call(gene_one, gene_two, factor)

		class ArithmeticCrossover

			def initialize(interpolation_function)
				@interpolation_function = interpolation_function
			end

			def recombine(individual_one, individual_two)
				child_one = individual_one.deep_clone
				child_two = individual_two.deep_clone

				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(individual_one, individual_two)
				shorter.genome.each_with_index do |gene_one, index|
					gene_two = individual_two.genome[index]

					child_one.genome[index] = @interpolation_function.call(gene_one, gene_two, rand)
					child_two.genome[index] = @interpolation_function.call(gene_two, gene_one, rand)
				end

				[child_one, child_two]
			end

			def to_s
				"arithmetic crossover"
			end

		end

	end
end