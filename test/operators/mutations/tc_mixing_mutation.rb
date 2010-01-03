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


require 'shoulda'

require 'evosynth'
require 'test/util/test_individuals'


class MixingMutationTest < Test::Unit::TestCase

	GENOME_SIZE = 20

	context "a mixing mutation run on binary genome" do

		setup do
			@mutation = EvoSynth::Mutations::MixingMutation.new
			@individual = TestBinaryIndividual.new(GENOME_SIZE)
			GENOME_SIZE.times { |index| @individual.genome[index] = (index % 2 == 1) ? 0 : 1 }
		end

		context "before mutation is executed" do

			should "genes should alternate between 0 and 1" do
				previous = 0
				@individual.genome.each do |gene|
					assert_not_equal previous, gene
					previous = gene
				end
			end

			should "the count of 0's and 1's should be the same" do
				count_ones, count_zeros = 0, 0
				@individual.genome.each { |gene| gene == 0 ? count_zeros += 1 : count_ones += 1 }
				assert_equal count_ones, count_zeros
			end
		end

		context "after mutations is executed" do

			should "the count of 0's and 1's should still be the same" do
				mutated = @mutation.mutate(@individual)
				count_ones, count_zeros = 0, 0
				mutated.genome.each { |gene| gene == 0 ? count_zeros += 1 : count_ones += 1 }
				assert_equal count_ones, count_zeros
			end

		end

	end

end
