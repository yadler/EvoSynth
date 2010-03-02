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
		NUM_PEAKS = 3
		MAX_GENERATIONS = 1000
		SOLUTIONS = 25
		PROBLEMS = 25

		class CMBEvaluator < EvoSynth::Evaluator
			# TODO: move this into superclass (Evaluator) - maybe use a special evolver?

			def toggle(result)
				1.0 - result
			end

			def encounter(problem, solution)
				result = EvoSynth::Problems::BinaryBenchmarkFuntions.n_peaks(problem.genome, solution.genome)
				solution.fitness = result
				problem.fitness = toggle(result)
				# TODO: what about memory? metaprogramming like in self adaptive gauss mutation? or explicit as memory = [] in invididual?

				# TODO: dirty hack - think about proper solution
				@calculated += 1
				@called += 1
				solution.fitness
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

		profile = EvoSynth::Profile.new(
			:mutation					=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN),
			:problem_mutation			=> EvoSynth::Mutations::MixingMutation.new,
			:problem_recombination		=> EvoSynth::Recombinations::Identity.new,
			:parent_selection			=> EvoSynth::Selections::FitnessProportionalSelection.new,
			:recombination				=> EvoSynth::Recombinations::KPointCrossover.new(2),
			:population					=> EvoSynth::Population.new(SOLUTIONS) { EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(GENOME_SIZE) { EvoSynth.rand_bool } ) },
			:problems					=> EvoSynth::Population.new(PROBLEMS) { EvoSynth::MaximizingIndividual.new(CMBExample.generate_problem(NUM_PEAKS)) },
			:evaluator					=> CMBEvaluator.new
		)

		evolver = EvoSynth::Evolvers::CMBCoevolutionary.new(profile)
		evolver.add_observer(EvoSynth::Output.create_console_logger(25,
			"generations"	=> ->{ evolver.generations_computed },
			"bestfitness"   => ->{ evolver.best_solution.fitness }
		))
		evolver.run_until_generations_reached(MAX_GENERATIONS)
	end
end