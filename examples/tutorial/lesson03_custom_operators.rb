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


# Load the EvoSynth library.

require 'evosynth'

# We create a simple bitflipping mutation. All we've to do is to create a class
# with mutate method that takes a individual as its argument.
# 
# HINT: You can always use the identity-operators as a skeleton for your own operators.

class MyMutation
	def mutate(individual)
		# ALWAYS deep_clone the given individual!
		mutated = individual.deep_clone
		# mutate and return the cloned individual
		rand_index = EvoSynth.rand(mutated.genome.size)
		mutated.genome[rand_index] = !mutated.genome[rand_index]
		mutated
	end
end

# Next we create a stupid recombination. This time we've to overwrite the recombine method,
# which takes two individuals as arguments and returns a array of two individuals.

class MyRecombination
	def recombine(individual_one, individual_two)
		# ALWAYS deep_clone the given individuals!
		child_one = individual_one.deep_clone
		child_two = individual_two.deep_clone
		# recombine and return the cloned individuals
		index = EvoSynth.rand(child_one.genome.size)
		child_one.genome[index], child_two.genome[index] = child_two.genome[index], child_one.genome[index]
		[child_one, child_two]
	end
end

# Now we create a (random) selection. To do this we've to overwrite the select method, which
# takes a population and a number of individuals to select as arguments.

class MySelection
	def select(population, select_count = 1)
		selected_population = EvoSynth::Population.new
		select_count.times { selected_population << population[EvoSynth.rand(population.size)] }
		selected_population
	end
end

# We use the evaluator and logger from lesson 1.

class MyEvaluator < EvoSynth::Evaluator
	def calculate_fitness(individual)
		individual.genome.inject(0.0) { |fitness, gene| fitness += gene ? 1 : 0 }
	end
end

# Instead of a hillclimber we now use a genetic algorithm.
#
# This evolver needs a population instead of a single Individual, so we just create
# a population of 25 individuals. We also use our custom mutation and recombination.

evolver = EvoSynth::Evolvers::GeneticAlgorithm.new do |ga|
	ga.evaluator         = MyEvaluator.new
	ga.mutation	         = MyMutation.new
	ga.recombination     = MyRecombination.new
	ga.parent_selection	 = MySelection.new
	ga.population        = EvoSynth::Population.new(25) { EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(64) { EvoSynth.rand_bool } ) }


	# create a logger like in lesson 1:
	ga.add_observer(EvoSynth::Logger.create(25, true, :gen, :best_fitness, :worst_fitness))
end

# Finally run the genetic algorithm and print the result after the evolution.
#
# The evolver will stop, when the fitness function got called 5000 times.

puts "\nRunning genetic algrithm...\n"
result = evolver.run_while { |ga| ga.evaluator.called < 5001 }
puts "\nPopulation after evolution:  #{result}"
