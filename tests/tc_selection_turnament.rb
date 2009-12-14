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
require 'tests/test_helper_indivdual'


class TestBestSelection < Test::Unit::TestCase

	def test_one
		pop = EvoSynth::Population.new()
		t1 = TestMinimizingIndividual.new(13)
		t2 = TestMinimizingIndividual.new(12)
		t3 = TestMinimizingIndividual.new(11)
		t4 = TestMinimizingIndividual.new(10)
		t5 = TestMinimizingIndividual.new(0)
		pop.add(t1)
		pop.add(t2)
		pop.add(t3)
		pop.add(t4)
		pop.add(t5)

		expected = EvoSynth::Population.new()
		expected.add(t5)
		result = EvoSynth::Selections.tournament(pop)
		assert_equal(expected, result)
	end

end