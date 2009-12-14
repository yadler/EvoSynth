#    Copyright (C) 2009 Yves Adler <yves.adler@googlemail.com>
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

# Author::    Yves Adler (mailto:yves.adler@googlemail.com)
# Copyright:: Copyright (C) 2009 Yves Adler
# License::   LGPLv3

require 'test/unit'
require 'evosynth'

class TestBinaryIndividual
	include EvoSynth::MinimizingIndividual

	def initialize(genome_size)
		@genome = EvoSynth::Genome.new(genome_size)
	end

	def fitness
		@fitness
	end

	def to_s
		@fitness.to_s + " - " + @genome.to_s
	end
end


class TestOneGeneFlipping < Test::Unit::TestCase

	def test_boolean_flipping
		individual = TestBinaryIndividual.new(100)
		individual.genome.map! { |gene| true }
		individual.genome.each { |gene| assert_equal(true, gene) }

		count = 0
		100.times do
			mutated = EvoSynth::Mutations.binary_mutation(individual, 0.1)
			mutated.genome.each { |gene| count += 1 if !gene }
		end

		assert_in_delta(10, Float(count) / 100, 0.5)
	end

end