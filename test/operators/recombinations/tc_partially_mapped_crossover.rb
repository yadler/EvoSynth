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

class PartiallyMappedCrossoverTest < Test::Unit::TestCase

	context "a partially mapped crossover run on example genome (Weicker page 133)" do

		setup do
			@recombination = EvoSynth::Recombinations::PartiallyMappedCrossover.new

			@individual_one = TestGenomeIndividual.new([1,4,6,5,7,2,3])
			@individual_two = TestGenomeIndividual.new([1,2,3,4,5,6,7])
		end

		context "before the partially mapped crossover is executed" do

			should "individual one should contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert @individual_one.genome.include? item }
			end

			should "individual two should contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert @individual_two.genome.include? item }
			end

		end

		context "after the partially mapped crossover is executed" do

			setup do
				@child_one, @child_two = @recombination.recombine(@individual_one, @individual_two)
			end

			should "parent one should (still) contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert @individual_one.genome.include? item }
			end

			should "parent two should (still) contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert @individual_two.genome.include? item }
			end

			should "both children should (still) contain all numbers from 1 to 7" do
				[1,2,3,4,5,6,7].each { |item| assert @child_one.genome.include? item }
				[1,2,3,4,5,6,7].each { |item| assert @child_two.genome.include? item }
			end

		end

	end

end