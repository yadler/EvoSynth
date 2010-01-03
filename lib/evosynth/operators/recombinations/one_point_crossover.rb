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

		# EIN-PUNKT-CROSSOVER (Weicker Page 84)
		# FIXME: refactor, improve, test me!

		class OnePointCrossover

			def recombine(individual_one, individual_two)
				child_one = individual_one.deep_clone
				child_two = individual_two.deep_clone
				shorter = EvoSynth::Recombinations.individual_with_shorter_genome(individual_one, individual_two)

				crossover_point = rand(shorter.genome.size)

				crossover_point.times do |index|
					child_one.genome[index] = individual_one.genome[index]
					child_two.genome[index] = individual_two.genome[index]
				end

				crossover_point.upto(shorter.genome.size - 1) do |index|
					child_one.genome[index] = individual_two.genome[index]
					child_two.genome[index] = individual_one.genome[index]
				end

				[child_one, child_two]
			end

			def to_s
				"1-point crossover"
			end

		end

	end
end
