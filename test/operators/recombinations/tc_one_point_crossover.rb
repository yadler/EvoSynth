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


class OnePointCrossoverTest < Test::Unit::TestCase

	GENOME_SIZE = 2000

	context "a one-point-crossover run on binary genome" do

		setup do
			@recombination = EvoSynth::Recombinations::OnePointCrossover.new

			@individual_one = TestBinaryIndividual.new(GENOME_SIZE)
			@individual_one.genome.map! { |gene| true }
			@individual_two = TestBinaryIndividual.new(GENOME_SIZE)
			@individual_two.genome.map! { |gene| false }
		end

		context "before one-point-crossover is executed" do

			should "all genes of individual one should be true" do
				@individual_one.genome.each { |gene| assert_equal true, gene }
			end

			should "all genes of individual two should be false" do
				@individual_two.genome.each { |gene| assert_equal false, gene }
			end

		end

		context "after one-point-crossover is executed" do

			setup do
				@child_one, @child_two = @recombination.recombine(@individual_one, @individual_two)
			end

			should "all genes of the parent one should (still) be true" do
				@individual_one.genome.each { |gene| assert_equal true, gene }
			end

			should "all genes of the parent two should (still) be false" do
				@individual_two.genome.each { |gene| assert_equal false, gene }
			end

			should "the count of 0's and 1's should still be the same" do
				@child_one.genome.each_with_index { |gene, index| assert_equal !gene, @child_two.genome[index] }
			end

		end

	end

end