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


module EvoSynth
	module Decoder

		# Converts a binary gray code bitstring (either 1/0 or true/false) into a standard binary bitstring.

		def Decoder.gray_to_binary(gray)
			rev_stdbin = Array.new(gray.size)
			gray.reverse!

			rev_stdbin[gray.size - 1] = gray[gray.size - 1]
			(gray.size - 2).downto(0) { |index| rev_stdbin[index] = rev_stdbin[index + 1] ^ gray[index] }

			rev_stdbin.reverse
		end

		# Converts a standard binary bitstring (either 1/0 or true/false) into a gray code bitstring.

		def Decoder.binary_to_gray(binary)
			gray = Array.new(binary)

			popped = gray.pop
			gray.unshift(popped ^ popped)
			gray.each_index { |index| gray[index] = binary[index] ^ gray[index]}

			gray
		end

	end

end