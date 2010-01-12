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


require 'set'


module EvoSynth
	module Recombinations

		# ORDNUNGSREKOMBINATION (Weicker page 29)
		# 
		# TODO: this can only recombine permutations? (see partially mapped crossover)
		#       -> at least it only works on genomes without duplicate genes!

		class OrderedRecombination

			def recombine(parent_one, parent_two)
				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(parent_one, parent_two)

				child_one = recombine_to_one(parent_one, parent_two, shorter)
				child_two = recombine_to_one(parent_two, parent_one, shorter)

				[child_one, child_two]
			end

			def to_s
				"ordered recombination"
			end

			private

			def recombine_to_one(parent_one, parent_two, shorter)
				child = parent_one.deep_clone

				rand_index = rand(shorter.genome.size)
				used_genes = child.genome[0..rand_index].to_set

				insert_index = rand_index + 1
				parent_two.genome.each_with_index do |gene, index|
					next if used_genes.include?(gene)

					child.genome[insert_index] = gene
					used_genes << gene
					insert_index += 1
					break if insert_index >= child.genome.size
				end

				child
			end

		end

	end
end
