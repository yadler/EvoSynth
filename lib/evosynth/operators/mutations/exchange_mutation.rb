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

		# <b>Relies on:</b> deep_clone (see below)
		#
		# This mutations exchanges two genes in the genome of a given individual
		# and returns a mutated individual. It does not change the given individual.
		#
		# The given individual has to provide a <i>deep_clone</i> method,
		# which clones the individual and its genome.
		

		class ExchangeMutation

			#	:call-seq:
			#		mutate(Individual) -> Individual
			#
			# Returns the mutation of a given individual.
			#
			#     m = ExchangeMutation.new
			#     m.mutate(a_individual)   #=> a_new_individual

			def mutate(individual)
				mutated = individual.deep_clone
				genome = mutated.genome

				index_one = rand(genome.size)
				index_two = rand(genome.size)
				index_two = rand(genome.size) while index_two == index_one

				genome[index_one], genome[index_two] = genome[index_two], genome[index_one]

				mutated
			end

			#	:call-seq:
			#		mutation.to_s -> string
			#
			# Returns description of this mutation
			#
			#     m = ExchangeMutation.new
			#     m.to_s                   #=> "exchange mutation"

			def to_s
				"exchange mutation"
			end

		end

	end
end