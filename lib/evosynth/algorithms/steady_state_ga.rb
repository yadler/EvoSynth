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

		# STEADY-STATE-GA (Weicker Page 129)

		class SteadyStateGA

			attr_accessor :mutation, :selection, :recombination,
			              :recombination_probability

			def initialize(population, recombination_probability = 0.5)
				@population = population
				@recombination_probability = recombination_probability

				@mutation = EvoSynth::Mutations::BinaryMutation.new
				@selection = EvoSynth::Selections::FitnessProportionalSelection.new
				@recombination = EvoSynth::Recombinations::OnePointCrossover.new
			end

			def run(generations)
				generations.times do
					parents = @selection.select(@population, 2)

					if rand < @recombination_probability
						child = @recombination.recombine(parents[0], parents[1])[0]
					else
						child = parents[1]
					end

					@population.remove(@population.worst)
					@population.add(@mutation.mutate(child))
				end

				@population
			end
		end

	end
end
