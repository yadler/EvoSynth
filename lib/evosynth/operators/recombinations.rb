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
		MUTATION_RATE = 5;

		# FIXME implement me! ;)

		def one_point_crossover(one, two)

		end


		# FIXME implement a proper two point crossover instead of this mess

		def two_point_crossover(one, two)
			start = rand(one.genome.size)
			length = rand(one.genome.size - start)

			length.times do |i|
				one.genome[start+i], two.genome[start+i] = two.genome[start+i], one.genome[start+i]
			end
		end

	end

end