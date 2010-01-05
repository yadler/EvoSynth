#    Copyright (C) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
#
#    This file is part of EvoSynth, a framework for rapid prototyping of
#    evolutionary and genetic algorithms.
#
#    EvoSynth is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    EvoSynth is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with EvoSynth.  If not, see <http://www.gnu.org/licenses/>.


module EvoSynth
	module Recombinations

		# ABBILDUNGSREKOMBINATION (Weicker Page 133)
		
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
				used_genes = parent_two.genome[range]

				range = 0..(index_one - 1)
				fill_range(range, mapping, used_genes, parent_one, child)

				range = (index_two + 1)..shorter.genome.size
				fill_range(range, mapping, used_genes, parent_one, child)

				child
			end

			def fill_range(range, mapping, used_genes, parent, child)
				range.each do |index|
					gene = parent.genome[index]
					gene = mapping[gene] while used_genes.include?(gene)
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
				genome_to.each_index { |index| mapping[genome_from[index]] = genome_to[index] }
				mapping
			end

		end

	end
end
