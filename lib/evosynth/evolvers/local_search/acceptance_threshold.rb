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
	module Evolvers

		class LocalSearch < EvoSynth::Evolver

			# AKZEPTANZ-TA (Weicker Page 157)

			class ThresholdAcceptance
				attr_accessor :temperature, :alpha

				DEFAULT_START_TEMP = Float::MAX
				DEFAULT_ALPHA = 0.9

				def initialize(start_temp = DEFAULT_START_TEMP, alpha = DEFAULT_ALPHA)
					@temperature = start_temp
					@alpha = alpha
				end

				def accepts(parent, child, generation)
					threshold = Math.sqrt( (child.fitness - parent.fitness)**2 )
					accepted = child > parent || threshold <= @temperature
					@temperature *= @alpha

					accepted
				end

				def to_s
					"Threshold Acceptance"
				end

			end

		end

	end
end