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
	module Recombinations

		# EIN-PUNKT-CROSSOVER (Weicker Page 84)

		class OnePointCrossover

			def recombine(parent_one, parent_two)
				child_one = parent_one.deep_clone
				child_two = parent_two.deep_clone

				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(parent_one, parent_two)
				crossover_point = EvoSynth.rand(shorter.genome.size)

				first_range = 0..crossover_point
				child_one.genome[first_range] =  parent_one.genome[first_range]
				child_two.genome[first_range] =  parent_two.genome[first_range]

				second_range = (crossover_point + 1)..(shorter.genome.size - 1)
				child_one.genome[second_range] = parent_two.genome[second_range]
				child_two.genome[second_range] = parent_one.genome[second_range]

				[child_one, child_two]
			end

			def to_s
				"one-point crossover"
			end

		end

	end
end
