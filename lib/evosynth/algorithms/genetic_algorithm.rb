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

		# GENETISCHER-ALGORITHMUS (Weicker Page 85)

		class GeneticAlgorithm

			attr_accessor :mutation, :selection, :recombination,
			              :recombination_probability

			def initialize(population, recombination_probability = 0.75)
				@population = population
				@recombination_probability = recombination_probability

				@selection = EvoSynth::Selections::FitnessProportionalSelection.new
				@crossover = EvoSynth::Recombinations::OnePointCrossover.new
				@mutation = EvoSynth::Mutations::BinaryMutation.new(0.01)
			end

			def run(generations)

				generations.times do
					selected_pop = @selection.select(@population, @population.size/2)
					@population.clear_all

					selected_pop.individuals.each_index do |index_one|
						# TODO: this could be avoided by #cycle which is introduced by 1.9
						index_two = index_one + 1
						index_two = -1 if index_two >= selected_pop.size

						if rand < @recombination_probability
							recombined = @crossover.recombine(selected_pop[index_one], selected_pop[index_two])
							child_one = recombined[0]
							child_two = recombined[1]
						else
							child_one = selected_pop[index_one]
							child_two = selected_pop[index_two]
						end

						@population.add(@mutation.mutate(child_one))
						@population.add(@mutation.mutate(child_two))
					end
				end

				@population
			end

		end

	end
end