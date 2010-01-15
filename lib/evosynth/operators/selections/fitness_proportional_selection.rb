#	Copyright (c) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
#
#	Permission is hereby granted, free of charge, to any person
#	obtaining a copy of this software and associated documentation
#	files (the "Software"), to deal in the Software without
#	restriction, including without limitation the rights to use,
#	copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the
#	Software is furnished to do so, subject to the following
#	conditions:
#
#	The above copyright notice and this permission notice shall be
#	included in all copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#	OTHER DEALINGS IN THE SOFTWARE.


module EvoSynth

	module Selections

		# FITNESSPROPORTIONALE-SELETION (Weicker Page 71)

		class FitnessProportionalSelection

			def select(population, select_count = 1)
				selected_population = EvoSynth::Core::Population.new
				fitness_hash = generate_fitness_hash(population)

				select_count.times do
					limit = rand(fitness_hash.values.max).floor
					next_individual = select_next_individual(population, limit, fitness_hash)
					selected_population.add(next_individual)
				end

				selected_population
			end

			def to_s
				"fitness proportional selection"
			end

			private

			def generate_fitness_hash(population)
				fitness_hash = {}
				fitness_sum = 0.0

				# we need to invert the fitnesse's only if we minimize!
				max_fitness = population.worst.fitness if population[0].minimizes?

				population.each_with_index do |individual, index|
					if population[0].minimizes?
						fitness_sum +=  max_fitness - individual.fitness + 1
					else
						fitness_sum += individual.fitness
					end

					fitness_hash[index] = fitness_sum
				end

				fitness_hash
			end

			def select_next_individual(population, limit, fitness_hash)
				population.each_with_index do |individual, index|
					return individual if fitness_hash[index] >= limit
				end
			end

		end

	end

end