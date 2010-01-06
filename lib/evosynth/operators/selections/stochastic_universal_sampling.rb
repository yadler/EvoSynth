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

		# STOCHASTISCHES-UNIVERSELLES-SAMPLING (Weicker Page 75)
		# FIXME: add RSPec (find testcase!)
		# TODO: rename to RoulettewheelSelection or not?

		class StochasticUniversalSampling

			def select(population, select_count = 1)
				selected_population = Population.new

				fitness_sum = 0.0
				population.each { |individual| fitness_sum += individual.fitness }

				limit = rand(fitness_sum / select_count)

				select_count.times do
					next_individual = select_next_individual(population, limit)
					selected_population.add(next_individual)
					limit += fitness_sum / select_count
				end

				selected_population
			end

			def to_s
				"stochastic universal sampling"
			end

			private

			def select_next_individual(population, limit)
				selection_sum = 0.0
				population.each do |individual|
					selection_sum += individual.fitness
					return individual if (selection_sum >= limit)
				end
			end

		end
	end
end
