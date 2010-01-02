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
# Copyright:: Copyright (C) 2010 Yves Adler
# License::   LGPLv3

require 'test/unit'
require 'shoulda'

require 'evosynth'
require 'test/util/test_individuals'


class ShiftingMutationTest < Test::Unit::TestCase

	GENOME_SIZE = 10

	context "a shifting mutation run on binary genome" do

		setup do
			@mutation = EvoSynth::Mutations::ShiftingMutation.new
			@individual = TestBinaryIndividual.new(GENOME_SIZE)
			GENOME_SIZE.times { |index| @individual.genome[index] = (index % 2 == 1) ? true : false}
		end

		context "before mutation is executed" do

			should "genes should alternate between true and false" do
				previous = true
				@individual.genome.each do |gene|
					assert_equal !previous, gene
					previous = gene
				end
			end

		end

		context "after mutations is executed" do

			should "no idea how to test it (yet)" do
				mutated = @mutation.mutate(@individual)
#				puts @individual
#				puts mutated
			end

		end

	end

end
