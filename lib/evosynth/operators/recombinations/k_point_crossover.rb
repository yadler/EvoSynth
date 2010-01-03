#    Copyright (C) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
#
#    This file is part of EvoSynth, a framework for rapid prototyping of
#    evolutionary and genetic algorithms.
#
#    EvoSynth is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    EvoSynth is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with EvoSynth.  If not, see <http://www.gnu.org/licenses/>.


module EvoSynth
	module Recombinations

		# K-PUNKT-CROSSOVER (Weicker Page 130)
		# TODO: implement real 2-point-crossover for better performance?

		class KPointCrossover

			attr_accessor :k

			def initialize(k = 2)
				@k = k
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
				@k.times { points << rand(genome_length) }
				points.sort!
				points[0] = 0
				points[@k-1] = genome_length
				points
			end

		end

	end
end