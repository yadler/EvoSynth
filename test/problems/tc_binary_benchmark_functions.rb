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


class BenchmarkFunctionsTest < Test::Unit::TestCase

	context "the count ones function" do

		should "be zero at [0,0,0,0,0,0,0]" do
			bs = [0,0,0,0,0,0,0]
			assert_equal 0, EvoSynth::Problems::BinaryBenchmarkFuntions.count_ones(bs)
		end

		should "be zero at [false,false,false,false,false,false,false]" do
			bs = [false,false,false,false,false,false,false]
			assert_equal 0, EvoSynth::Problems::BinaryBenchmarkFuntions.count_ones(bs)
		end

		should "be [1,1,1,1,1,1,1].size at [1,1,1,1,1,1,1]" do
			bs = [1,1,1,1,1,1,1]
			assert_equal bs.size, EvoSynth::Problems::BinaryBenchmarkFuntions.count_ones(bs)
		end

		should "be [true,true,true,true,true,true,true].size at [true,true,true,true,true,true,true]" do
			bs = [true,true,true,true,true,true,true]
			assert_equal bs.size, EvoSynth::Problems::BinaryBenchmarkFuntions.count_ones(bs)
		end

		should "be [1,1,1,5,1,0,1].size - 2 at [1,1,1,5,1,0,1]" do
			bs = [1,1,1,5,1,0,1]
			assert_equal bs.size - 2, EvoSynth::Problems::BinaryBenchmarkFuntions.count_ones(bs)
		end
	end

end
