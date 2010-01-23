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
	module Algorithms

		# STEADY-STATE-GA (Weicker Page 129)

		class SteadyStateGA
			include EvoSynth::Algorithms::Algorithm

			def initialize(profile)
				init_profile :mutation, :selection, :recombination, :population, :fitness_calculator, :recombination_probability => 0.75
				use_profile profile

				@population.each { |individual| @fitness_calculator.calculate_and_set_fitness(individual) }
			end

			def to_s
				"steady-state genetic algoritm <mutation: #{@mutation}, selection: #{@selection}, recombination: #{@recombination}>"
			end

			def best_solution
				@population.best
			end

			def worst_solution
				@population.worst
			end

			def return_result
				@population
			end

			def next_generation
				parents = @selection.select(@population, 2)

				if rand < @recombination_probability
					child = @recombination.recombine(parents[0], parents[1])[0]
				else
					child = parents[1]
				end

				child = @mutation.mutate(child)
				@fitness_calculator.calculate_and_set_fitness(child)

				@population.remove(@population.worst)
				@population.add(child)
			end

		end

	end
end
