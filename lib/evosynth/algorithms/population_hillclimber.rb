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
	module Algorithms

		# POPULATIONSBASIERTES-BINÄRES-HILLCLIMBING (Weicker Page 65)

		class PopulationHillclimber

			def initialize(population)
				@population = population
				@mutation = EvoSynth::Mutations::OneGeneFlipping.new
			end

			def run(generations)
				generations.times do
					@population.map! { |individual| mutate(individual) }
				end

				@population
			end

			private

			def mutate(individual)
				child = @mutation.mutate(individual)
				individual = child > individual ? child : individual
			end

		end

	end
end
