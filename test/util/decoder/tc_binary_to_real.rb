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


class GrayDecoderTest < Test::Unit::TestCase

	should "decode [0,0,0,0,0] to lower bound" do
		binary = [0,0,0,0,0]
		assert_equal -5, EvoSynth::Decoder.binary_to_real(binary, -5.0, 5.0)
	end

	should "decode [1,1,1,1,1] to upper bound" do
		binary = [1,1,1,1,1]
		assert_equal 5, EvoSynth::Decoder.binary_to_real(binary, -5, 5)
	end

	should "decode [true,false,false,false,false] to lower bound" do
		binary = [false,false,false,false,false]
		assert_equal -5, EvoSynth::Decoder.binary_to_real(binary, -5.0, 5.0)
	end

	should "decode [true,true,true,true,true] to upper bound" do
		binary = [true,true,true,true,true]
		assert_equal 5, EvoSynth::Decoder.binary_to_real(binary, -5, 5)
	end

end
