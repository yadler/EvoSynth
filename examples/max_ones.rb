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

module MaxOnes
	class BinaryIndividual
		include EvoSynth::MaximizingIndividual

		def initialize(genome_size)
			@genome = EvoSynth::Genome.new(genome_size)
			@genome.collect! { |gene| rand(2) > 0 ? true : false}
		end

		def fitness
			@fitness = 0
			@genome.each { |gene| @fitness += 1 if gene }
			@fitness
		end
	end
end

individual = MaxOnes::BinaryIndividual.new(10)
hillclimber = EvoSynth::Strategies::Hillclimber.new(individual)
result = hillclimber.run(100)
puts result