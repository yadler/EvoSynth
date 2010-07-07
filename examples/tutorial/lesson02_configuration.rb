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

# We use the evaluator from lesson 1:

class MyEvaluator < EvoSynth::Evaluator
	def calculate_fitness(individual)
		individual.genome.inject(0.0) { |fitness, gene| fitness += gene ? 1 : 0 }
	end
end

# If we want to try more than one evolutionary algorithm we can use the configuration class to
# keep all operators and datastructures in one place. The use of a configuration is in most cases
# optional and only makes sense when more than one algorithm comes into play.
#
# Here we will use the hillclimber from lesson one and a genetic algorithm, therefor we've to
# provide a individual AND a population in our configuration

configuration = EvoSynth::Configuration.new do |conf|
	conf.evaluator	= MyEvaluator.new
	conf.mutation	= EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
	conf.individual	= EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(64) { EvoSynth.rand_bool } )
	conf.population	= EvoSynth::Population.new(20) { EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(64) { EvoSynth.rand_bool } ) }
end

# Create a hillclimber with the configuration and add a logger as observer
hc = EvoSynth::Evolvers::Hillclimber.new(configuration)
hc.add_observer(EvoSynth::Logger.create(500, true, :gen, :best_fitness, :worst_fitness))

# Run the hillclimber...
puts "\nRunning Hillclimber...\n"
result = hc.run_while { configuration.evaluator.called < 5000 }
puts "\nIndividual after evolution:  #{configuration.individual}"

# Reset the counters of the evaluator!
configuration.evaluator.reset_counters

# Create a genetic algorithm (with weak elitism) with the configuration and add a logger as observer
ga = EvoSynth::Evolvers::GeneticAlgorithm.new(configuration)
EvoSynth::Evolvers.add_weak_elistism(ga)
ga.add_observer(EvoSynth::Logger.create(25, true, :gen, :best_fitness, :worst_fitness))

# Run the GA...
puts "\nRunning Genetic Algorithm with elitism...\n"
result = ga.run_while { configuration.evaluator.called < 5000 }
puts "\nBest Individual after evolution:  #{result.best}"