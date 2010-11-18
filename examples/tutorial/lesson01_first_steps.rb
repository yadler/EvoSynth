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

# Create a Evaluator subclass to implement the fitness function.
#
# You have to overwrite thhe calculate_fitness method, which will get an individual as parameter.
# This example function is the classic OnesMax function, which just count's the ones in a bitstring.

class MyEvaluator < EvoSynth::Evaluator
	def calculate_fitness(individual)
		individual.genome.inject(0.0) { |fitness, gene| fitness += gene ? 1 : 0 }
	end
end

# Create the hillclimber-evolver, it needs a individual, a evaluator and a mutation
#
#     - we use a MaximizingIndividual (fitness will get maximized during the evolution),
#       with a ArrayGenome, which contains 64 (random) booleans
#     - as evaluator we use the MyEvaluator we've just created
#     - lastly, we use the BinaryMutation to flip the boolean values in the genome

evolver = EvoSynth::Evolvers::Hillclimber.new do |hc|
	hc.evaluator	= MyEvaluator.new
	hc.individual	= EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(64) { EvoSynth.rand_bool } )
	hc.mutation		= EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
end

# Create a logger with console output using a factory method.
# 
# This one will log the current generation, the best and the worst fitness every 500 generations

logger = EvoSynth::Logger.create(500, true, :gen, :best_fitness, :worst_fitness)
evolver.add_observer(logger)

# Finally run the hillclimber and print the result after the evolution.
# 
# The hillclimber will stop, when the fitness function got called 5000 times.

puts "\nRunning hillclimber...\n"
result = evolver.run_while { |hc| hc.evaluator.called < 5001 }
puts "\nIndividual after evolution:  #{result}"
