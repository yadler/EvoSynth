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

		# FIXME: refactor, improve and test me some more!
		
		class PartiallyMappedCrossover

			def recombine(parent_one, parent_two)
				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(parent_one, parent_two)
				index_one, index_two = rand_indexes(shorter)
				child_one = recombine_to_one(parent_one, parent_two, index_one, index_two)
				child_two = recombine_to_one(parent_two, parent_one, index_one, index_two)

				[child_one, child_two]
			end

			def recombine_to_one(parent_one, parent_two, index_one, index_two)
				child = parent_one.deep_clone
				child.genome.fill { 0 }
				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(parent_one, parent_two)

				range = (index_one..index_two)
				child.genome[range] = parent_two.genome[range]
				used_genes = parent_two.genome[range]

				mapping = mapping_array(parent_one.genome, parent_two.genome)

				range = 0..(index_one - 1)
				range.each do |index|
					x = parent_one.genome[index]
					x = mapping[x] while used_genes.include?(x)
					child.genome[index] = x
					used_genes << x
				end

				range = (index_two + 1)..shorter.genome.size
				range.each do |index|
					x = parent_one.genome[index]
					x = mapping[x] while used_genes.include?(x)
					child.genome[index] = x
					used_genes << x
				end

				child
			end

			def to_s
				"mapping recombination"
			end

			private

			def rand_indexes(shorter)
				index_one = rand(shorter.genome.size - 2) + 1
				index_two = rand(shorter.genome.size - 2) + 1
				index_one, index_two = index_two, index_one if index_one > index_two
				[index_one, index_two]
				[1,3]
			end

			def mapping_array(genome_from, genome_to)
				mapping = Hash.new
				genome_to.each_index { |index| mapping[genome_from[index]] = genome_to[index] }
				mapping
			end

		end

	end
end

require 'evosynth'
class TestIndividual
	include EvoSynth::MaximizingIndividual

	attr_accessor :genome

	def initialize(genes)
		@genome = EvoSynth::Genome.new(genes)
		@fitness = 0.0
	end

	def calculate_fitness
		@fitness
	end

	def to_s
		@genome.to_s
	end
end

require 'evosynth'

one = TestIndividual.new([1,4,6,5,7,2,3])
#one.fill { |i| i }
two = TestIndividual.new([1,2,3,4,5,6,7])
#two.fill { |i| 9-i }
puts one.to_s
puts two.to_s

recombination = EvoSynth::Recombinations::PartiallyMappedCrossover.new

puts
#puts recombination.recombine_to_one(one, two)
puts
puts recombination.recombine(one, two)