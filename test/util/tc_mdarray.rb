#	Copyright (c) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
#
#	Permission is hereby granted, free of charge, to any person
#	obtaining a copy of this software and associated documentation
#	files (the "Software"), to deal in the Software without
#	restriction, including without limitation the rights to use,
#	copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the
#	Software is furnished to do so, subject to the following
#	conditions:
#
#	The above copyright notice and this permission notice shall be
#	included in all copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#	OTHER DEALINGS IN THE SOFTWARE.


require 'shoulda'

require 'evosynth'


class ArrayGenomeTest < Test::Unit::TestCase

	#FIXME: this test case is pretty incomplete

	context "when first created" do
		setup do
			@mda = EvoSynth::Util::MDArray.new(1, 2)
		end

		should "every element should be nil" do
			@mda.each_index { |row, col| assert_nil @mda[row, col] }
		end

	end

	context "when created with default value (0)" do
		setup do
			@mda = EvoSynth::Util::MDArray.new(1, 3, 0)
		end

		should "every element should be 0" do
			@mda.each_index { |row, col| assert_equal 0, @mda[row, col] }
		end

		should "after assignment of 1 to a element, it should be one" do
			assert_equal 0, @mda[0,0]
			@mda[0,0] = 1
			assert_equal 1, @mda[0,0]
		end
	end

end