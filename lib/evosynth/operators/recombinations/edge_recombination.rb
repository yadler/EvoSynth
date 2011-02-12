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

		# KANTENREKOMBINATION (Weicker page 29)
		#
		# this can only recombine permutations (see partially mapped crossover).

		class EdgeRecombination

			def recombine(parent_one, parent_two)
				child_one = recombine_to_one(parent_one, parent_two)
				child_two = recombine_to_one(parent_two, parent_one)

				[child_one, child_two]
			end

			def to_s
				"edge recombination"
			end

			private

			def recombine_to_one(parent_one, parent_two)
				child = parent_one.deep_clone
				child_genome = child.genome
				adj_matrix = generate_adj_matrix(parent_one.genome, parent_two.genome)

				start = EvoSynth.rand_bool ? parent_one.genome[0] : parent_two.genome[0]
				child_genome[0] = start

				child_genome.each_index do |index|
					next if index == 0
					child_genome[index] = find_next_gene(adj_matrix, start)
					start = child_genome[index]
				end

				child
			end

			def find_next_gene(adj_matrix, start)
				reachable = adj_matrix.delete(start)
				next_gene, min = nil, nil
				
				reachable.each do |gene|
					next unless adj_matrix.has_key?(gene)

					neighbors = adj_matrix[gene]
					adj_size = neighbors.size

					if min.nil?
						min = adj_size
						next_gene = gene
					elsif adj_size <= min
						next if adj_size == min && EvoSynth.rand_bool # if equal let the fortune decide

						min = adj_size
						next_gene = gene
					end
				end

				next_gene = adj_matrix.keys.sample if next_gene.nil?

				next_gene
			end

			def generate_adj_matrix(genome_one, genome_two)
				adj_mat = {}
				genome_one.each { |gene| adj_mat[gene] = Set.new }

				[genome_one, genome_two].each do |genome|
					genome.each_with_index do |gene, index|
						right_neighbor = genome[(index + 1) % genome.size]
						adj_mat[gene] << right_neighbor
						adj_mat[right_neighbor] << gene
					end
				end

				adj_mat
			end
		end

	end
end
