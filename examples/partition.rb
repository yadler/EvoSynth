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


require 'set'
require 'evosynth'


module Examples
	module Partitionproblem

		class PartitionEvaluator < EvoSynth::Evaluator
			def calculate_fitness(individual)
				sum_a = individual.partition_a.inject(0) { |sum, n| sum + n }
				sum_b = individual.partition_b.inject(0) { |sum, n| sum + n }
				(sum_a - sum_b).abs
			end
		end

		# We've to carefully overwrite functions here, because we actually have 2 genomes

		class PartitionIndividual < EvoSynth::MinimizingIndividual

			attr_accessor :partition_a, :partition_b

			def initialize(partition_a, partition_b)
				@partition_a = partition_a;
				@partition_b = partition_b;
				@fitness = Float::MAX
			end

			def fitness=(value)
				@fitness = value
				@partition_a.changed = false
				@partition_b.changed = false
			end

			def deep_clone
				my_clone = self.clone
				my_clone.partition_a = Marshal.load( Marshal.dump( self.partition_a ) )
				my_clone.partition_b = Marshal.load( Marshal.dump( self.partition_b ) )
				my_clone
			end

			def changed?
				@partition_a.changed? || @partition_b.changed?
			end

			def to_s
				"partition individual <fitness = #{fitness}, partition_a.size = #{@partition_a.size}, partition_b.size = #{@partition_b.size}>"
			end

		end

		class PartitionMutation

			def mutate(individual)
				mutated = individual.deep_clone
				part_a, part_b = mutated.partition_a, mutated.partition_b

				if EvoSynth.rand_bool
					part_a << part_b.delete_at(EvoSynth.rand(part_b.size)) unless mutated.partition_b.empty?
				else
					part_b << part_a.delete_at(EvoSynth.rand(part_a.size)) unless mutated.partition_a.empty?
				end

				mutated
			end

			def to_s
				"custom made mutation for the partition problem"
			end

		end


		# these are just Testdata generators

		module Testdata

			def Testdata.gen_tiny_set
				problem = Array.new(25)
				problem.fill { |i| i }
			end

			def Testdata.gen_layer_set
				problem = Set.new
				problem.add(EvoSynth.rand(1000) * EvoSynth.rand(1000)) while problem.size < 200
				problem.add(EvoSynth.rand(1000)) while problem.size < 1000
				problem.to_a
			end

			def Testdata.gen_standard_set
				problem = Array.new
				1000.times { |i| problem.insert(-1, i)  }
				problem
			end

			def Testdata.gen_random_set
				problem = Set.new
				problem.add(EvoSynth.rand(1000000)) while problem.size < 1000
				problem.to_a
			end

			def Testdata.gen_big_set
				problem = Set.new
				problem.add(EvoSynth.rand(10000) * 100) while problem.size < 1000
				problem.to_a
			end
		end

		# creates a new (random) individual from a given problem

		def Partitionproblem.get_new_individual_from(problem)
			border = EvoSynth.rand(problem.size)
			part_a, part_b = EvoSynth::ArrayGenome.new, EvoSynth::ArrayGenome.new

			problem.size.times do
				|index| index < border ? part_a << problem[index] : part_b << problem[index]
			end

			Partitionproblem::PartitionIndividual.new(part_a, part_b)
		end

		POPULATION_SIZE = 20
		GENERATIONS = 500
		GOAL = 0.0

		problem = Partitionproblem::Testdata.gen_layer_set
		base_population = EvoSynth::Population.new(POPULATION_SIZE) { Partitionproblem.get_new_individual_from(problem) }

		configuration = EvoSynth::Configuration.new(
			:mutation			=> PartitionMutation.new,
			:parent_selection	=> EvoSynth::Selections::TournamentSelection.new(3),
			:recombination		=> EvoSynth::Recombinations::Identity.new,
			:evaluator			=> Partitionproblem::PartitionEvaluator.new
		)

		configuration.population = base_population.deep_clone
		puts "running MemeticAlgorithm with elitism..."
		evolver = EvoSynth::Evolvers::MemeticAlgorithm.new(configuration)
		EvoSynth::Evolvers.add_weak_elistism(evolver)
		logger = EvoSynth::Output::Logger.new(25) do |log|
			log.add_column("generations",  ->{ evolver.generations_computed })
			log.add_column("best fitness", ->{ evolver.best_solution.fitness })
			log.add_column("best",         ->{ evolver.best_solution.to_s })
			log.add_observer(EvoSynth::Output::ConsoleWriter.new)
		end
		evolver.add_observer(logger)

		evolver.run_until { |gen, best| best.fitness <= GOAL || gen >= GENERATIONS }
		puts "\nResult after #{evolver.generations_computed} generations: #{evolver.best_solution}"
	end
end