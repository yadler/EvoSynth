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

	def initialize
	end

	def fitness
		0.0
	end
end


class TestSelection < Test::Unit::TestCase

	def test_stupid
		p = EvoSynth::Population.new(10) { TestIndividual.new }
#		assert_equal(p.to_s, "Population (size=10, individuals=[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil])", "to_s failed")
#		assert_nil(p.best, "foo")
		puts EvoSynth::Selections::select_best(p);
		puts EvoSynth::Selections::select_turnier(p);
	end

end
