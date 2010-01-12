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

		# ABBILDUNGSREKOMBINATION (Weicker Page 133)
		# TODO: is this maybe the first recombination (will not be the last) that can only combine permutations?
		#       -> at least it only works on genomes without duplicate genes!

		class PartiallyMappedCrossover

			def recombine(parent_one, parent_two)
				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(parent_one, parent_two)
				indexes = rand_indexes(shorter)
				child_one = recombine_to_one(parent_one, parent_two, indexes, shorter)
				child_two = recombine_to_one(parent_two, parent_one, indexes, shorter)

				[child_one, child_two]
			end

			def to_s
				"mapping recombination"
			end

			private

			def recombine_to_one(parent_one, parent_two, indexes, shorter)
				child = parent_one.deep_clone
				mapping = mapping_array(parent_one.genome, parent_two.genome)

				index_one, index_two = indexes
				range = (index_one..index_two)
				child.genome[range] = parent_two.genome[range]
				used_genes = parent_two.genome[range].to_set

				range = 0..(index_one - 1)
				fill_range(range, mapping, used_genes, parent_one, child)

				range = (index_two + 1)..(shorter.genome.size - 1)
				fill_range(range, mapping, used_genes, parent_one, child)

				child
			end

			def fill_range(range, mapping, used_genes, parent, child)
				range.each do |index|
					gene = parent.genome[index]
					first_gene = gene

					while used_genes.include?(gene) do
						gene = mapping[gene]
						raise "duplicate gene in genome. would cause infinite loop!" if gene == first_gene
					end

					child.genome[index] = gene
					used_genes << gene
				end
			end

			def rand_indexes(shorter)
				index_one = rand(shorter.genome.size)
				index_two = rand(shorter.genome.size)
				index_one, index_two = index_two, index_one if index_one > index_two
				[index_one, index_two]
			end

			def mapping_array(genome_from, genome_to)
				mapping = Hash.new
				genome_from.each_with_index { |gene, index| mapping[gene] = genome_to[index] }
				mapping
			end

		end

	end
end
