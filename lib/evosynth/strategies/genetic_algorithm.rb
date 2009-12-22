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
	module Strategies

		class GeneticAlgorithm

			def initialize(population)
				@population = population
				@recombination_probability = 0.6
			end

			def run(generations)
				selection = EvoSynth::Selections::FitnessProportionalSelection.new
				crossover = EvoSynth::Recombinations::OnePointCrossover.new
				mutation = EvoSynth::Mutations::BinaryMutation.new

				generations.times do
					selected_pop = selection.select(@population, @population.size)
					@population.clear_all

					(selected_pop.size / 2).times do |index|
						if rand < @recombination_probability
							recombined = crossover.recombine(selected_pop[2*index - 1], selected_pop[2*index])
							child_one = recombined[0]
							child_two = recombined[1]
						else
							child_one = selected_pop[2*index - 1]
							child_two = selected_pop[2*index]
						end

						@population.add(mutation.mutate(child_one))
						@population.add(mutation.mutate(child_two))
					end
				end

				@population
			end

		end

	end
end