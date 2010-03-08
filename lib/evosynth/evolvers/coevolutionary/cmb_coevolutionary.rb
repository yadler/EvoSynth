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


module EvoSynth
	module Evolvers

		# based on "Coevolution, Memory and Balance" from Paredis, 1999

		class CMBCoevolutionary
			include EvoSynth::Evolvers::Evolver

			DEFAULT_PAIRING_RUNS = 20
			DEFAULT_SELECTION = EvoSynth::Selections::FitnessProportionalSelection.new
			DEFAULT_RECOMBINATION = EvoSynth::Recombinations::KPointCrossover.new(2)
			DEFAULT_RECOMBINATION_PROBABILITY = 0.75

			def initialize(profile)
				init_profile :population,
					:problems,
				    :evaluator,
					:mutation,
				    :problem_mutation,
					:recombination => DEFAULT_RECOMBINATION,
				    :problem_recombination => DEFAULT_RECOMBINATION,
					:parent_selection => DEFAULT_SELECTION,
					:enviromental_selection => DEFAULT_SELECTION,
					:pairing_runs => DEFAULT_PAIRING_RUNS

				use_profile profile

				# intialize fitnesses?! FIXME: find a better way to do this
				solution = @parent_selection.select(@population, 1).first
				@problems.each do |problem|
					@evaluator.encounter(problem, solution)
				end

				problem = @parent_selection.select(@problems, 1).first
				@population.each do |solution|
					@evaluator.encounter(problem, solution)
				end
			end

			def to_s
				"C-M-B coevolutionary algorithm <mutation: #{@mutation}, recombination: #{@recombination}, parent selection: #{@parent_selection}, enviromental selection: #{@enviromental_selection}>"
			end

			def best_solution
				@population.best
			end

			def worst_solution
				@population.worst
			end

			def return_result
				@population
			end

			def next_generation
				@pairing_runs.times do
					problem = @parent_selection.select(@problems, 1).first
					solution = @parent_selection.select(@population, 1).first
					@evaluator.encounter(problem, solution)
				end

				# select, recombine and mutate problem child
				parents = @parent_selection.select(@problems, 2)
				child = @problem_recombination.recombine(parents[0], parents[1])[0] # only one offspring each generation!
				child = @problem_mutation.mutate(child)

				@problems.add(child)
				@problems.remove(@problems.worst)

				# select, recombine and mutate solution child
				parents = @parent_selection.select(@population, 2)
				child = @recombination.recombine(parents[0], parents[1])[0] # only one offspring each generation!
				child = @mutation.mutate(child)

				@population.add(child)
				@population.remove(@population.worst)
			end

		end

	end
end