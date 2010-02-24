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

	# Right now this is just a fascade to Kernel.rand - overwrite if you want to change
	# the random number generator of EvoSynth (uniform distributed)
	#
	# TODO: add proper documentation

	def EvoSynth.rand(*args)
		Kernel.rand(*args)
	end

	# TODO: add proper documentation

	def EvoSynth.rand_bool
		EvoSynth.rand(2) > 0
	end

	# polar form of the Box-Mueller (see: http://www.taygeta.com/random/gaussian.html)
	# todo proper documentation
	
	def EvoSynth.normal_rand
		x1, x2, w, = 0.0, 0.0, 0.0, 0.0

		begin
			x1 = 2.0 * EvoSynth.rand - 1.0
			x2 = 2.0 * EvoSynth.rand - 1.0
			w = x1 ** 2 + x2 ** 2;
		end while ( w >= 1.0 )

		w = Math.sqrt( (-2.0 * Math.log( w ) ) / w )
		x2 * w
	end

	# Right now this is just a fascade to Kernel.rand - overwrite if you want to change
	# the random number generator of EvoSynth
	#
	# TODO: add proper documentation

	def EvoSynth.srand(*args)
		Kernel.srand(*args)
	end

end