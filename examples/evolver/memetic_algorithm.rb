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

	module Memetic

		class MyEvaluator < EvoSynth::Evaluator
			def calculate_fitness(individual)
				EvoSynth::Problems::FloatBenchmarkFuntions.rastgrin(individual.genome)
			end
		end

		evaluator = MyEvaluator.new

		subevolver_conf = EvoSynth::Configuration.new do |conf|
			conf.mutation	= EvoSynth::Mutations::BinaryMutation.new( ->(gene){ EvoSynth.rand * 10.24 - 5.12 } )
			conf.evaluator	= evaluator
		end

		evolver = EvoSynth::Evolvers::MemeticAlgorithm.new do |ma|
			ma.mutation			= EvoSynth::Mutations::UniformRealMutation.new
			ma.evaluator		= evaluator
			ma.population		= EvoSynth::Population.new(20) do
				EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new(64) { EvoSynth.rand * 10.24 - 5.12 } )
			end

			ma.subevolver				= EvoSynth::Evolvers::LocalSearch
			ma.subevolver_configuration = subevolver_conf

			# toggle 'brute force' local search with:
			# 	ma.individual_learning_probability = -1

			EvoSynth::Evolvers.add_weak_elistism(ma)
			ma.add_observer(EvoSynth::Logger.create(5, true, :gen, :best_fitness))
		end

		puts "running MemeticAlgorithm with elitism and 'brute force' local search ..."
		evolver.run_while { |evolver| evolver.best_solution?.fitness != 0.0 && evolver.evaluator.called <= 10000 }
		puts "\nResult after #{evolver.generations_computed} generations: #{evolver.best_solution?}"
	end

end