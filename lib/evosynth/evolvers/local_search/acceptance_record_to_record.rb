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

		class LocalSearch < EvoSynth::Evolvers::Evolver

			# AKZEPTANZ-RR (Weicker Page 158)

			class RecordToRecordTravelAcceptance
				attr_accessor :delta, :alpha

				DEFAULT_START_DELTA = Float::MAX
				DEFAULT_ALPHA = 0.9

				def initialize(start_delta = DEFAULT_START_DELTA, alpha = DEFAULT_ALPHA)
					@delta = start_delta
					@alpha = alpha
					@best = nil
				end

				def accepts(parent, child, generation)
					@best = parent if @best.nil?
					accepted = false

					if child > @best
						@best = child
						accepted = true
					else
						threshold = Math.sqrt( (child.fitness - @best.fitness)**2 )
						accepted = threshold < @delta
					end

					@delta *= @alpha
					accepted
				end

				def to_s
					"Record-to-Record-Travel Acceptance"
				end

			end

		end

	end
end