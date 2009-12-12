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


class TestPopulation < Test::Unit::TestCase

	def test_stupid
		p = EvoSynth::Population.new(10) { TestIndividual.new }
# 		assert_equal(p.to_s, "Population (size=10, individuals=[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil])", "to_s failed")
#		assert_nil(p.best, "foo")
		puts "to_s = " +  p.to_s
		puts "best = " +  p.best.to_s
		puts "worst = " +  p.worst.to_s
		puts "first = " + p[0].to_s
		puts "last = " + p[p.size - 1].to_s
		p.sort!
	end

	def test_klammern
		p = EvoSynth::Population.new(2) { TestIndividual.new }
		p[0] = "foo"
		assert_equal(p[0], "foo", "klammer kaputt")
		p[0] = "bar"
		assert_equal(p[0], "bar", "klammer kaputt")
		p[1] = "baz"
		assert_equal(p[1], "baz", "klammer kaputt")
	end

	def test_size
		p = EvoSynth::Population.new(0) { TestIndividual.new }
		assert_equal(p.size, 0, "Population should be of size 0")
		p = EvoSynth::Population.new(100) { TestIndividual.new }
		assert_equal(p.size, 100, "Population should be of size 0")
	end
end
