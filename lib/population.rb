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

require 'individual'

module EvoSynth

	# This class is used to create and maintain a population

	class Population

		include Enumerable

		# Setup a population of individuals with the given size
		# and a block to initialize each individual

		def initialize(size = 0, &individual_creator)
			@individuals = Genome.new(size)
			@individuals.collect! { |individual| individual_creator.call } if block_given?
		end


        def each
			@individuals.each { |individual| yield individual }
        end


		def sort!(*args)
			@individuals = @individuals.sort!(*args)
		end


		def add(individual)
			@individuals + [individual]
		end


		def best
			@individuals.sort! { |a,b| a.fitness <=> b.fitness }
			@individuals.first
		end


		def worst
			@individuals.sort! { |a,b| a.fitness <=> b.fitness }
			@individuals.last
		end


		def [](index)
			@individuals[index]
		end


		def []=(index, individual)
			@individuals[index] = individual
		end


		def size
			@individuals.size
		end


		def to_s
			"Population (size=" + @individuals.size.to_s + ", individuals=" + @individuals.to_s + ")"
		end

	end

end
