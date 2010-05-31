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


# TODO: transfer this into separate examples: binary benchmark example, float benchmark example, ...

module Examples
	module SPk

		class SPkFitnessEvaluator < EvoSynth::Evaluator

			def initialize(k)
				@k = k
				super()
			end

			def calculate_fitness(individual)
				EvoSynth::Problems::BinaryBenchmarkFuntions.sp_k(@k, individual.genome)
			end

		end
 
		K = 3
		GENOME_SIZE = 16
		GENERATIONS = 5000

		evolver = EvoSynth::Evolvers::Hillclimber.new do |hc|
			hc.individual = EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(GENOME_SIZE) { EvoSynth.rand_bool } )
			hc.mutation	  = EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
			hc.evaluator  = SPkFitnessEvaluator.new(K)
		end

		logger = EvoSynth::Logger.new(500) do |log|
			log.add_column("generations",  ->{ evolver.generations_computed })
			log.add_column("best fitness", ->{ evolver.best_solution.fitness })
			log.add_observer(EvoSynth::Export::ConsoleWriter.new)
		end
		evolver.add_observer(logger)

		puts "Running #{evolver}...\n\n"
		result = evolver.run_until_generations_reached(GENERATIONS)
		puts "\nResult: #{result}"
	end
end