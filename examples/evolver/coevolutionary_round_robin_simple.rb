#	Copyright (c) 2010 Yves Adler <yves.adler@googlemail.com>
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


require 'evosynth'


module Examples

	# This example is EvoSynth's interpretation of DeJong and Potter's CCGA presented in
	# "A Cooperative Coevolutionary Approach to Function Optimization" (1994)

	module CCGAExample

		def CCGAExample.fitness_function(xs)
			EvoSynth::Problems::FloatBenchmarkFuntions.rosenbrock(xs)
		end

		class CCGABenchmarkEvaluator < EvoSynth::Evaluator
			def initialize(populations, dimensions)
				super()
				@populations, @dimensions = populations, dimensions
			end

			def decode(individual)
				values = (0 .. @dimensions - 1).to_a
				values.map! do |index|
					if index == individual.population_index
						EvoSynth::Decoder.binary_to_real(individual.genome, -5.12, 5.12)
					else
						EvoSynth::Decoder.binary_to_real(@populations[index].best.genome, -5.12, 5.12)
					end
				end
			end

			def calculate_fitness(individual)
				CCGAExample.fitness_function(decode(individual))
			end
		end

		class CCGAIndividual < EvoSynth::MinimizingIndividual
			attr_accessor :population_index

			def initialize(population_index, *args)
				super(*args)
				@population_index = population_index
			end
		end

		BITS = 16
		DIMENSIONS = 5
		MAX_EVALUATIONS = 25000
		POP_SIZE = 25

		# create a population for each dimension:

		populations = (0 .. DIMENSIONS - 1).to_a
		populations.map! do |dim|
			EvoSynth::Population.new(POP_SIZE) do
				CCGAIndividual.new(dim, EvoSynth::ArrayGenome.new(BITS) { EvoSynth.rand_bool })
			end
		end

		# create the configuration:

		configuration = EvoSynth::Configuration.new do |c|
			c.mutation					= EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
			c.parent_selection			= EvoSynth::Selections::FitnessProportionalSelection.new
			c.recombination				= EvoSynth::Recombinations::KPointCrossover.new(2)
			c.recombination_probability	= 0.6
			c.populations				= populations
			c.evaluator					= CCGABenchmarkEvaluator.new(populations, populations.size)
		end

		# create a logger, this one has to do something special ;-)

		logger = EvoSynth::Logger.create(50, true, :gen) do |log|
			log.add_column("fitness", Proc.new { |evolver|
				best_phenotype = evolver.best_solution?.map { |individual| EvoSynth::Decoder.binary_to_real(individual.genome, -5.12, 5.12) }
				CCGAExample.fitness_function(best_phenotype)
			})
		end

		# lets roll...

		evolver = EvoSynth::Evolvers::RoundRobinCoevolutionary.new(configuration)
		evolver.add_observer(logger)

		result = evolver.run_while { configuration.evaluator.called < MAX_EVALUATIONS }

		# print some results...

		puts "\nbest 'combined' individual:"
		best = result.map { |pop| puts "\t#{pop.best}"; pop.best }
		best_genome = best.map { |individual| EvoSynth::Decoder.binary_to_real(individual.genome, -5.12, 5.12) }

		puts "\nbest 'combined' genome:"
		puts "\t#{best_genome.inspect}"
		puts "\n\tfitness = #{CCGAExample.fitness_function(best_genome)}"
	end
end