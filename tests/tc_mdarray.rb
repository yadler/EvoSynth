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


class TestPopulation < Test::Unit::TestCase

	def test_to_s
		mda = EvoSynth::Util::MDArray.new(2, 3, 0)
#		puts mda
	end

	def test_constructor_nil
		mda = EvoSynth::Util::MDArray.new(1,1)
		assert_nil(mda[0,0])
	end

	def test_index_error
		mda = EvoSynth::Util::MDArray.new(1,2)
		assert_raise(IndexError) {mda[2,1]} # raise row error
		assert_raise(IndexError) {mda[0,2]} # raise col error
	end

	def test_assign
		mda = EvoSynth::Util::MDArray.new(1,1)
		assert_nil(mda[0,0])
		mda[0,0] = "foo"
		assert_equal(mda[0,0], "foo")
	end

	def test_each
		mda = EvoSynth::Util::MDArray.new(1,3,0)
		mda.each do |row, col|
			assert_equal(mda[row,col], 0)
		end
	end
end
