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


require 'observer'


module EvoSynth

	# Baseclass for all fitness evaluators. It also counts how often it was used to calculate
	# the fitness of a given individual and how often it actually calculated the fitness.
	#
	# For simple problems you just need to overwrite calculate_fitness(individual)
	#
	# Obervers get notified each time calculate_and_set_fitness(individual) gets called, not on actual calculations

	class Evaluator
		include Observable

		# How often did the Evaluator return a fitness value

		attr_reader :called

		# How often did the Evaluator actually calculate a fitness value

		attr_reader :calculated

		# Returns a new Evaluator object

		def initialize
			reset_counters
		end

		# Calculates and sets the fitness of the given individual if the individual has changed,
		# otherwise it just returns the cached fitness of the individual

		def calculate_and_set_fitness(individual)
			@called += 1

			if individual.changed?
				@calculated += 1
				individual.fitness = calculate_fitness(individual)
			end

			changed
			notify_observers self, @called
			individual.fitness
		end

		# Calculates and sets the initial fitness of the given individual.

		def calculate_and_set_initial_fitness(individual)
			@called += 1
			@calculated += 1

			individual.fitness = calculate_initial_fitness(individual)

			changed
			notify_observers self, @called
			individual.fitness
		end

		# This function is actually used to calculate the fitness of a individual. It's the "fitness function".

		def calculate_fitness(individual)
			raise NotImplementedError, "please implement calculate_fitness!"
		end

		# This function is used to calculate an intitial fitness value for a individual. Calls calculate_fitness by default.

		def calculate_initial_fitness(individual)
			calculate_fitness(individual)
		end

		# Reset the called/calculated counters of the Evaluator

		def reset_counters
			@called = 0
			@calculated = 0
		end

		# Returns a human readable reprasentation of the Evaluator

		def to_s
			"Evaluator <called: #{@called}, calculated: #{@calculated}>"
		end
	end

end