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
#require 'profile'

module Examples
	module MaxOnes

		GENOME_SIZE = 25
		POP_SIZE = 25
		MAX_EVALUATIONS = 25000

		# this is just for the sake of demonstration stuff - you could also use
		# EvoSynth::Problems::BinaryBenchmarkFuntions.count_ones()

		class MaxOnesEvaluator < EvoSynth::Core::Evaluator
			def calculate_fitness(individual)
				individual.genome.inject(0.0) { |fitness, gene| fitness += gene ? 1 : 0 }
			end
		end

		def MaxOnes.create_individual
			EvoSynth::Core::MaximizingIndividual.new( EvoSynth::Core::ArrayGenome.new(GENOME_SIZE) { EvoSynth.rand_bool } )
		end

		profile = EvoSynth::Core::Profile.new(
			:individual			=> MaxOnes.create_individual,
			:population			=> EvoSynth::Core::Population.new(POP_SIZE) { MaxOnes.create_individual },
			:evaluator			=> MaxOnes::MaxOnesEvaluator.new,
			:mutation			=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
		)

		EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Evolvers::Hillclimber.new(profile)) { profile.evaluator.called < MAX_EVALUATIONS }
		profile.evaluator.reset_counters
		EvoSynth::Util.run_algorith_with_benchmark(EvoSynth::Evolvers::ElitismGeneticAlgorithm.new(profile))  { profile.evaluator.called < MAX_EVALUATIONS }
	end
end