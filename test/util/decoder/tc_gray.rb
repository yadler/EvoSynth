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

	should "decode gray to standard binary (on 1,0)" do
		assert_equal [0,0,0,0], EvoSynth::Decoder.gray_to_binary([0,0,0,0])
		assert_equal [0,0,0,1], EvoSynth::Decoder.gray_to_binary([0,0,0,1])
		assert_equal [0,0,1,0], EvoSynth::Decoder.gray_to_binary([0,0,1,1])
		assert_equal [0,0,1,1], EvoSynth::Decoder.gray_to_binary([0,0,1,0])
		assert_equal [0,1,0,0], EvoSynth::Decoder.gray_to_binary([0,1,1,0])
		assert_equal [0,1,0,1], EvoSynth::Decoder.gray_to_binary([0,1,1,1])
		assert_equal [0,1,1,0], EvoSynth::Decoder.gray_to_binary([0,1,0,1])
		assert_equal [0,1,1,1], EvoSynth::Decoder.gray_to_binary([0,1,0,0])
		assert_equal [1,0,0,0], EvoSynth::Decoder.gray_to_binary([1,1,0,0])
		assert_equal [1,0,0,1], EvoSynth::Decoder.gray_to_binary([1,1,0,1])
		assert_equal [1,0,1,0], EvoSynth::Decoder.gray_to_binary([1,1,1,1])
		assert_equal [1,0,1,1], EvoSynth::Decoder.gray_to_binary([1,1,1,0])
		assert_equal [1,1,0,0], EvoSynth::Decoder.gray_to_binary([1,0,1,0])
		assert_equal [1,1,0,1], EvoSynth::Decoder.gray_to_binary([1,0,1,1])
		assert_equal [1,1,1,0], EvoSynth::Decoder.gray_to_binary([1,0,0,1])
		assert_equal [1,1,1,1], EvoSynth::Decoder.gray_to_binary([1,0,0,0])
	end

	should "decode standard binary to gray (on 1,0)" do
		assert_equal [0,0,0,0], EvoSynth::Decoder.binary_to_gray([0,0,0,0])
		assert_equal [0,0,0,1], EvoSynth::Decoder.binary_to_gray([0,0,0,1])
		assert_equal [0,0,1,1], EvoSynth::Decoder.binary_to_gray([0,0,1,0])
		assert_equal [0,0,1,0], EvoSynth::Decoder.binary_to_gray([0,0,1,1])
		assert_equal [0,1,1,0], EvoSynth::Decoder.binary_to_gray([0,1,0,0])
		assert_equal [0,1,1,1], EvoSynth::Decoder.binary_to_gray([0,1,0,1])
		assert_equal [0,1,0,1], EvoSynth::Decoder.binary_to_gray([0,1,1,0])
		assert_equal [0,1,0,0], EvoSynth::Decoder.binary_to_gray([0,1,1,1])
		assert_equal [1,1,0,0], EvoSynth::Decoder.binary_to_gray([1,0,0,0])
		assert_equal [1,1,0,1], EvoSynth::Decoder.binary_to_gray([1,0,0,1])
		assert_equal [1,1,1,1], EvoSynth::Decoder.binary_to_gray([1,0,1,0])
		assert_equal [1,1,1,0], EvoSynth::Decoder.binary_to_gray([1,0,1,1])
		assert_equal [1,0,1,0], EvoSynth::Decoder.binary_to_gray([1,1,0,0])
		assert_equal [1,0,1,1], EvoSynth::Decoder.binary_to_gray([1,1,0,1])
		assert_equal [1,0,0,1], EvoSynth::Decoder.binary_to_gray([1,1,1,0])
		assert_equal [1,0,0,0], EvoSynth::Decoder.binary_to_gray([1,1,1,1])
	end

	should "decode gray to standard binary (on true,false)" do
		assert_equal [false,false,false,false], EvoSynth::Decoder.gray_to_binary([false,false,false,false])
		assert_equal [false,false,false,true], EvoSynth::Decoder.gray_to_binary([false,false,false,true])
		assert_equal [false,false,true,false], EvoSynth::Decoder.gray_to_binary([false,false,true,true])
		assert_equal [false,false,true,true], EvoSynth::Decoder.gray_to_binary([false,false,true,false])
		assert_equal [false,true,false,false], EvoSynth::Decoder.gray_to_binary([false,true,true,false])
		assert_equal [false,true,false,true], EvoSynth::Decoder.gray_to_binary([false,true,true,true])
		assert_equal [false,true,true,false], EvoSynth::Decoder.gray_to_binary([false,true,false,true])
		assert_equal [false,true,true,true], EvoSynth::Decoder.gray_to_binary([false,true,false,false])
		assert_equal [true,false,false,false], EvoSynth::Decoder.gray_to_binary([true,true,false,false])
		assert_equal [true,false,false,true], EvoSynth::Decoder.gray_to_binary([true,true,false,true])
		assert_equal [true,false,true,false], EvoSynth::Decoder.gray_to_binary([true,true,true,true])
		assert_equal [true,false,true,true], EvoSynth::Decoder.gray_to_binary([true,true,true,false])
		assert_equal [true,true,false,false], EvoSynth::Decoder.gray_to_binary([true,false,true,false])
		assert_equal [true,true,false,true], EvoSynth::Decoder.gray_to_binary([true,false,true,true])
		assert_equal [true,true,true,false], EvoSynth::Decoder.gray_to_binary([true,false,false,true])
		assert_equal [true,true,true,true], EvoSynth::Decoder.gray_to_binary([true,false,false,false])
	end

	should "decode standard binary to gray (on true,false)" do
		assert_equal [false,false,false,false], EvoSynth::Decoder.binary_to_gray([false,false,false,false])
		assert_equal [false,false,false,true], EvoSynth::Decoder.binary_to_gray([false,false,false,true])
		assert_equal [false,false,true,true], EvoSynth::Decoder.binary_to_gray([false,false,true,false])
		assert_equal [false,false,true,false], EvoSynth::Decoder.binary_to_gray([false,false,true,true])
		assert_equal [false,true,true,false], EvoSynth::Decoder.binary_to_gray([false,true,false,false])
		assert_equal [false,true,true,true], EvoSynth::Decoder.binary_to_gray([false,true,false,true])
		assert_equal [false,true,false,true], EvoSynth::Decoder.binary_to_gray([false,true,true,false])
		assert_equal [false,true,false,false], EvoSynth::Decoder.binary_to_gray([false,true,true,true])
		assert_equal [true,true,false,false], EvoSynth::Decoder.binary_to_gray([true,false,false,false])
		assert_equal [true,true,false,true], EvoSynth::Decoder.binary_to_gray([true,false,false,true])
		assert_equal [true,true,true,true], EvoSynth::Decoder.binary_to_gray([true,false,true,false])
		assert_equal [true,true,true,false], EvoSynth::Decoder.binary_to_gray([true,false,true,true])
		assert_equal [true,false,true,false], EvoSynth::Decoder.binary_to_gray([true,true,false,false])
		assert_equal [true,false,true,true], EvoSynth::Decoder.binary_to_gray([true,true,false,true])
		assert_equal [true,false,false,true], EvoSynth::Decoder.binary_to_gray([true,true,true,false])
		assert_equal [true,false,false,false], EvoSynth::Decoder.binary_to_gray([true,true,true,true])
	end
end
