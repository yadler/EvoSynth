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

	# Uniform distributed (between 0.0 and 1.0) pseudo-random number generator of EvoSynth,
	# overwrite this function if you want to change the uniform distributed random number
	# generator of EvoSynth.
	# 
	# This a fascade to Kernel.rand. For a complete documentation see the Ruby documentation of rand().

	def EvoSynth.rand(*args)
		Kernel.rand(*args)
	end

	# Returns a pseudo-random boolean value (true or false).

	def EvoSynth.rand_bool
		EvoSynth.rand(2) > 0
	end

	#	:call-seq:
	#		EvoSynth.nrand				#=> pseudo-random normal distributed random number
	#		EvoSynth.nrand(3.2)			#=> pseudo-random normal distributed random number around 3.2
	#		EvoSynth.nrand(2.4, 1.5)	#=> pseudo-random normal distributed random number around 2.4 with sigma = 1.5
	#
	# Normal distributed pseudo-random number generator of EvoSynth. Uses the polar form of
	# the Box-Mueller transformation to transform two Uniform distributed random numbers into
	# one normal distributed random number (see: http://www.taygeta.com/random/gaussian.html=).

	def EvoSynth.nrand(mu = 0.0, sigma = 1.0)
		x1, x2, w, = 0.0, 0.0, 0.0, 0.0

		begin
			x1 = 2.0 * EvoSynth.rand - 1.0
			x2 = 2.0 * EvoSynth.rand - 1.0
			w = x1 ** 2.0 + x2 ** 2.0;
		end while ( w >= 1.0 )

		w = Math.sqrt( (-2.0 * Math.log( w ) ) / w )
		mu + (x2 * w * sigma)
	end

	# Set the seed of the uniform distributed random number generator of EvoSynth.
	#
	# This a fascade to Kernel.srand, for a complete documentation see the Ruby documentation of srand().

	def EvoSynth.srand(*args)
		Kernel.srand(*args)
	end


	# Returns a random element of the given array

	def EvoSynth.rand_element(array)
		array.sample
	end

end
