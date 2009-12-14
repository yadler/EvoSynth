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
require 'tests/test_helper_indivdual'


class TestPopulation < Test::Unit::TestCase

	def test_min
		pop = EvoSynth::Population.new()
		t1 = TestMinimizingIndividual.new(1)
		t2 = TestMinimizingIndividual.new(2)
		t3 = TestMinimizingIndividual.new(3)
		pop.add(t3)
		pop.add(t1)
		pop.add(t2)
		pop.sort!

		expected = EvoSynth::Population.new()
		expected.add(t1)
		expected.add(t2)
		expected.add(t3)

		assert_equal(expected, pop)
	end

	def test_max
		pop = EvoSynth::Population.new()
		t1 = TestMaximizingIndividual.new(1)
		t2 = TestMaximizingIndividual.new(2)
		t3 = TestMaximizingIndividual.new(3)
		pop.add(t3)
		pop.add(t1)
		pop.add(t2)
		pop.sort!

		expected = EvoSynth::Population.new()
		expected.add(t3)
		expected.add(t2)
		expected.add(t1)

		assert_equal(expected, pop)
	end

	def test_best_worst_min
		p = EvoSynth::Population.new(10) { TestMinimizingIndividual.new(1) }
		min = TestMinimizingIndividual.new(0)
		max = TestMinimizingIndividual.new(2)
		p.add(min)
		p.add(max)
		assert_equal(12, p.size)
		
		assert_equal([min], p.best)
		assert_equal([max], p.worst)
	end

	def test_best_worst_max
		p = EvoSynth::Population.new(10) { TestMaximizingIndividual.new(1) }
		min = TestMaximizingIndividual.new(0)
		max = TestMaximizingIndividual.new(2)
		p.add(min)
		p.add(max)
		assert_equal(12, p.size)

		assert_equal([max], p.best)
		assert_equal([min], p.worst)
	end

	def test_no_block
		p = EvoSynth::Population.new(1)
		assert_nil(p[0])
	end

	def test_braces
		p = EvoSynth::Population.new(2) { TestMinimizingIndividual.new }
		p[0] = "foo"
		assert_equal(p[0], "foo", "klammer kaputt")
		p[0] = "bar"
		assert_equal(p[0], "bar", "klammer kaputt")
		p[1] = "baz"
		assert_equal(p[1], "baz", "klammer kaputt")
	end

	def test_size
		p = EvoSynth::Population.new(0) { TestMinimizingIndividual.new }
		assert_equal(p.size, 0, "Population should be of size 0")
		p = EvoSynth::Population.new(100) { TestMinimizingIndividual.new }
		assert_equal(p.size, 100, "Population should be of size 0")
	end
end
