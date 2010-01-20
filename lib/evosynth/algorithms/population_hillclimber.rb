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

		# POPULATIONSBASIERTES-BINÄRES-HILLCLIMBING (Weicker Page 65)

		class PopulationHillclimber
			include EvoSynth::Algorithms::Algorithm

			attr_accessor :mutation, :population, :fitness_calculator

			def initialize(profile)
				@population = profile.population
				@mutation = profile.mutation
				@fitness_calculator = profile.fitness_calculator

				@population.each { |individual| @fitness_calculator.calculate_and_set_fitness(individual) }
			end

			def to_s
				"population based hillclimber <mutation: #{@mutation}>"
			end

			def best_solution
				@population.best
			end

			def worst_solution
				@population.worst
			end

			private

			def return_result
				@population
			end

			def next_generation
				@population.map! { |individual| mutate(individual) }
			end

			def mutate(individual)
				child = @mutation.mutate(individual)
				@fitness_calculator.calculate_and_set_fitness(child)
				child > individual ? child : individual
			end

		end

	end
end
