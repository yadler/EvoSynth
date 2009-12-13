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


class TestIndividual
	include EvoSynth::Individual

	def initialize(fitness = 0.0)
		@fitness = fitness
	end

	def fitness
		@fitness
	end

	def to_s
		@fitness
	end
end


class TestBestSelection < Test::Unit::TestCase

	def test_simple
		pop = EvoSynth::Population.new()
		t1 = TestIndividual.new(1)
		t2 = TestIndividual.new(2)
		t3 = TestIndividual.new(3)
		t4 = TestIndividual.new(5)
		t5 = TestIndividual.new(20)
		pop.add(t1)
		pop.add(t2)
		pop.add(t3)
		pop.add(t4)
		pop.add(t5)

		should_be = EvoSynth::Population.new()
		should_be.add(t1)
		should_be.add(t2)
		result = EvoSynth::Selections.select_best(pop, 2)
		assert_equal(result, should_be)
	end
end