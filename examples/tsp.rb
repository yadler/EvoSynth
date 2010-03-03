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
require 'set'


module Examples
	module TSP

		def TSP.create_individual(problem)
			individual = EvoSynth::MinimizingIndividual.new
			shuffeld = (0..problem.size - 1).to_a.sort_by { EvoSynth.rand(2) }
			individual.genome = EvoSynth::ArrayGenome.new(shuffeld)
			individual
		end

		def TSP.optimal_tour(problem)
			optimal = TSP.create_individual(problem)
			opt_tour = [1,28,6,12,9,5,26,29,3,2,20,10,4,15,18,17,14,22,11,19,25,7,23,27,8,24,16,13,21].map! { |num| num -= 1 }
			optimal.genome = EvoSynth::ArrayGenome.new(opt_tour)
			optimal
		end

		tsp = nil
		begin
			tsp = EvoSynth::Problems::TSP.new('testdata/bays29.tsp')
		rescue
			puts "Could not load test data. Please see testdata/README for instructions..."
			exit(0)
		end

		optimal_tour = TSP.optimal_tour(tsp)

		profile = EvoSynth::Profile.new(
			:individual			=> TSP.create_individual(tsp),
			:mutation			=> EvoSynth::MetaOperators::ProportionalCombinedOperator.new(EvoSynth::Mutations::InversionMutation.new,
																							 EvoSynth::Mutations::ShiftingMutation.new,
																							 EvoSynth::Mutations::MixingMutation.new),
			:parent_selection	=> EvoSynth::Selections::TournamentSelection.new(3),
			:recombination		=> EvoSynth::Recombinations::EdgeRecombination.new,
			:population			=> EvoSynth::Population.new(100) { TSP.create_individual(tsp) },
			:evaluator			=> tsp
		)
		profile.evaluator.calculate_and_set_fitness(optimal_tour)

		puts "read testdata/bays29.tsp - problem contains #{tsp.size} cities...\n"
		puts "Optimal Individual for this problem: #{optimal_tour}"

		evolver = EvoSynth::Evolvers::GeneticAlgorithm.new(profile)
		EvoSynth::Evolvers.add_weak_elistism(evolver)
		evolver.add_observer(EvoSynth::Output.create_console_logger(25,
			"generations"	=> ->{ evolver.generations_computed },
			"bestfitness"   => ->{ evolver.best_solution.fitness },
			"worstfitness"  => ->{ evolver.worst_solution.fitness }
		))

		puts "\nRunning #{evolver}...\n"
		result = evolver.run_until_generations_reached(200)
		puts "\nBest Individual after evolution:  #{result.best}"
	end
end