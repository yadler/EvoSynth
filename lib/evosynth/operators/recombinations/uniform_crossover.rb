#    Copyright (C) 2009 Yves Adler <yves.adler@googlemail.com>
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

# Author::    Yves Adler (mailto:yves.adler@googlemail.com)
# Copyright:: Copyright (C) 2009 Yves Adler
# License::   LGPLv3


module EvoSynth
	module Recombinations

		#	UNIFORMER-CROSSOVER (Weicker Page 80)
		# FIXME: refactor, improve, test me!

		class UniformCrossover

			def recombine(individual_one, individual_two)
				child_one = individual_one.deep_clone
				child_two = individual_two.deep_clone

				if individual_one.genome.size > individual_one.genome.size then
					shorter = individual_two
					other = individual_one
				else
					shorter = individual_one
					other = individual_two
				end

				shorter.genome.each_index do |index|
					if (rand(2) > 0)
						child_one.genome[index] = shorter.genome[index]
						child_two.genome[index] = other.genome[index]
					else
						child_one.genome[index] = other.genome[index]
						child_two.genome[index] = shorter.genome[index]
					end
				end

				[child_one, child_two]
			end

		end

	end
end