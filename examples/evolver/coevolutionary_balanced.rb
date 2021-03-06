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


require 'evosynth'


module Examples

	# This example is based on "Coevolution, Memory and Balance" from Paredis, 1999

	module CMBExample

		GENOME_SIZE = 32
		NUM_PEAKS = 8
		MAX_GENERATIONS = 2000
		SOLUTIONS = 25
		PROBLEMS = 25

		class CMBEvaluator < EvoSynth::Evaluator
			# TODO: move this into superclass (Evaluator) - maybe use a special evaluator?

			def toggle(result)
				1.0 - result
			end

			# sets fitnesses and returns winner

			def encounter(problem, solution, set_problem_fitness = true, set_solution_fitness = true)
				result = EvoSynth::Problems::BinaryBenchmarkFuntions.n_peaks(problem.genome, solution.genome)

				solution.fitness = result if set_problem_fitness
				problem.fitness = toggle(result) if set_solution_fitness

				# TODO: dirty hack - think about proper solution
				@calculated += 1
				@called += 1

				solution.fitness > 0.5 ? solution : problem
			end
		end

		class CoEvoIndividual < EvoSynth::MaximizingIndividual
			# TODO: put this in a good place :)

			def initialize(*args)
				super(*args)
				@memory = []
				@memory_size = 1
			end

			def fitness=(value)
				if @memory.empty?
					@memory = [value] * @memory_size
				else
					@memory.pop
					@memory << value
				end
			end

			def fitness
				sum = @memory.inject(0.0) { |sum, value| sum += value }
				sum / @memory_size
			end

		end


		def CMBExample.generate_problem(peak_count)
			peaks = []
			peak_count.times do
				peak = []
				GENOME_SIZE.times { peak << EvoSynth.rand_bool }
				peaks << peak
			end
			EvoSynth::ArrayGenome.new(peaks)
		end


		configuration = EvoSynth::Configuration.new(
			:mutation					=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN),
			:problem_mutation			=> EvoSynth::Mutations::MixingMutation.new,
			:problem_recombination		=> EvoSynth::Recombinations::OnePointCrossover.new,
			:population					=> EvoSynth::Population.new(SOLUTIONS) { CoEvoIndividual.new( EvoSynth::ArrayGenome.new(GENOME_SIZE) { EvoSynth.rand_bool } ) },
			:problems					=> EvoSynth::Population.new(PROBLEMS) { CoEvoIndividual.new( CMBExample.generate_problem(NUM_PEAKS) ) },
			:evaluator					=> CMBEvaluator.new
		)

		evolver = EvoSynth::Evolvers::BalancedCoevolutionary.new(configuration)
		logger = EvoSynth::Logger.create(25, true, :gen, :best_fitness, :worst_fitness) do |log|
			log.add_column("solution_success", ->(evolver) { evolver.solution_success })
		end
		evolver.add_observer(logger)
		evolver.run_until_generations_reached(MAX_GENERATIONS)
	end
end