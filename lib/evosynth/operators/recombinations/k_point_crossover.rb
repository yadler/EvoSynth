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

		# K-PUNKT-CROSSOVER (Weicker Page 130)

		class KPointCrossover

			attr_accessor :k

			DEFAULT_K = 2

			def initialize(k = DEFAULT_K)
				@k = k
			end

			#Return a deep copy of this operator

			def deep_clone
				self.clone
			end

			def recombine(individual_one, individual_two)
				child_one = individual_one.deep_clone
				child_two = individual_two.deep_clone

				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(individual_one, individual_two)
				crossover_points = random_crossover_points(shorter.genome.size)

				@k.times do |m|
					begin
						range = (crossover_points[m] + 1)..crossover_points[m + 1]
					rescue ArgumentError
						next
					end

					if m % 2 == 1
						child_one.genome[range] = individual_two.genome[range]
						child_two.genome[range] = individual_one.genome[range]
					end
				end

				[child_one, child_two]
			end

			def to_s
				"k-point crossover (k=#{@k})"
			end

			private

			def random_crossover_points(genome_length)
				points = []
				@k.times { points << EvoSynth.rand(genome_length) }
				points.sort!
				points[0] = 0
				points[@k-1] = genome_length
				points
			end

		end

	end
end