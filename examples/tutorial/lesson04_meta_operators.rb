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

# Let's optimize a SP_k Problem ...

class SPkFitnessEvaluator < EvoSynth::Evaluator
	def initialize(k)
		@k = k
		super()
	end

	def calculate_fitness(individual)
		EvoSynth::Problems::BinaryBenchmarkFuntions.sp_k(@k, individual.genome)
	end
end

# This time we use some constants to easily change the essential parameters:

K = 3
GENOME_SIZE = 16
GENERATIONS = 500
POP_SIZE = 20

# Create a combined Mutation
# 
# This one will execute a Binary Mutation with a probability of 75%, the Exchange Mutation got only 25% probability.

meta_mutation = EvoSynth::MetaOperators::ProportionalCombinedOperator.new
meta_mutation.add(EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN), 0.75)
meta_mutation.add(EvoSynth::Mutations::ExchangeMutation.new, 0.25)

# Create a combined Rekombination
#
# We "fake" a 2-Point-Crossover in 50% of the cases, because the second 1-Point Crossover got only 50% execution probability

meta_recombination = EvoSynth::MetaOperators::SequentialCombinedOperator.new
meta_recombination.add(EvoSynth::Recombinations::OnePointCrossover.new)
meta_recombination.add(EvoSynth::Recombinations::OnePointCrossover.new, 0.5)

# Last but not least, we create a conditional Selection-Operator - sdont take this selection strategy too serious ;-)

meta_selection = EvoSynth::MetaOperators::ConditionalCombinedOperator.new
meta_selection.add(EvoSynth::Evolvers::GeneticAlgorithm::DEFAULT_SELECTION) { Time.now.to_i % 2 == 1 }
meta_selection.add(EvoSynth::Selections::RandomSelection.new)				{ Time.now.to_i % 2 == 0 }

# Setup a Genetic Algorithm with weak Elistism:

evolver = EvoSynth::Evolvers::GeneticAlgorithm.new do |ga|
	ga.population    = EvoSynth::Population.new(POP_SIZE) { EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(GENOME_SIZE) { EvoSynth.rand_bool } ) }
	ga.mutation	     = meta_mutation
	ga.recombination = meta_recombination
	ga.evaluator     = SPkFitnessEvaluator.new(K)

	ga.add_observer(EvoSynth::Logger.create(50, true, :gen, :best_fitness, :worst_fitness))
	EvoSynth::Evolvers.add_weak_elistism(ga)
end

# Let's roll...

puts "Running #{evolver}...\n\n"
result = evolver.run_until_generations_reached(GENERATIONS)
puts "\nBest found solution: #{result.best}"