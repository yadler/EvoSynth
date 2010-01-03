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

		# FIXME: finish implementation
		
		class PartiallyMappedCrossover

			def recombine(individual_one, individual_two)
				child_one = individual_one.deep_clone
				child_two = individual_two.deep_clone

				mapping_one_two = mapping_array(individual_one.genome, individual_two.genome)
				mapping_two_one = mapping_array(individual_two.genome, individual_one.genome)

				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(individual_one, individual_two)
				index_one = rand(individual_one.genome.size - 2) + 1
				index_two = rand(shorter.size)
				index_one, index_two = index_two, index_one if index_one > index_two

				[child_one, child_two]
			end

			def to_s
				"mapping recombination"
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

one = EvoSynth::Genome.new([1,4,6,5,7,2,3])
#one.fill { |i| i }
two = EvoSynth::Genome.new([1,2,3,4,5,6,7])
#two.fill { |i| 9-i }
puts one.to_s
puts two.to_s

recombination = EvoSynth::Recombinations::PartiallyMappedCrossover.new

puts recombination.mapping_array(one, two)
puts recombination.mapping_array(two, one)