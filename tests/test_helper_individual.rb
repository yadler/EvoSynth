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

require 'evosynth'


class TestIndividual
	attr_accessor :fitness

	def initialize(fitness = 0.0)
		@genome = EvoSynth::Genome.new
		@fitness = fitness
	end

	def calculate_fitness
		@fitness
	end

	def to_s
		@fitness
	end
end


class TestMinimizingIndividual < TestIndividual
	include EvoSynth::MinimizingIndividual
end


class TestMaximizingIndividual < TestIndividual
	include EvoSynth::MaximizingIndividual
end


# FIXME: replace this with a mocked object!

class TestBinaryIndividual
	include EvoSynth::MinimizingIndividual

	def initialize(genome_size)
		@genome = EvoSynth::Genome.new(genome_size)
	end

	def fitness
		@fitness
	end

	def to_s
		"#{@fitness} - #{@genome}"
	end
end