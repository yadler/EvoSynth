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

	class Genome < Array

		attr_accessor :changed

		def initialize(*args)
			super
			@changed = true
		end


		def [](*n)
			@changed = true
			super(*n)
		end

	end


	module Individual

		attr_accessor :genome

		def to_s
			"fitness = #{fitness}, genome = [#{genome}]"
		end

		def fitness
			if genome.changed
				@fitness = calculate_fitness
				@genome.changed = false
			end

			@fitness
		end

		def deep_clone
			my_clone = self.clone
			my_clone.genome = self.genome.clone
			my_clone
		end
	end


	# Mixin for Individuals (for minimizing Problems)

	module MinimizingIndividual
		include Individual
		include Comparable

		def <=>(anOther)
			cmp = fitness <=> anOther.fitness
			-1 * cmp
		end

	end

	# Mixin for Individuals (for maximizing Problems)

	module MaximizingIndividual
		include Individual
		include Comparable

		def <=>(anOther)
			fitness <=> anOther.fitness
		end

	end

end