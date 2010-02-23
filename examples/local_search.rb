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
	module LocalSearch

		VALUE_BITS = 16
		DIMENSIONS = 5
		GENERATIONS = 5000
		GENOME_SIZE = VALUE_BITS * DIMENSIONS
		UPPER_LIMIT = 5.12
		LOWER_LIMIT = -5.12

		class LocalSearchEvaluator < EvoSynth::Core::Evaluator

			def decode(individual)
				values = []
				DIMENSIONS.times do |dim|
					values << EvoSynth::Decoder.binary_to_real(individual.genome[dim * VALUE_BITS, VALUE_BITS], LOWER_LIMIT, UPPER_LIMIT)
				end
				values
			end

			def calculate_fitness(individual)
				EvoSynth::Problems::BenchmarkFuntions.sphere(decode(individual))
			end
		end

		def LocalSearch.create_individual
			EvoSynth::Core::MinimizingIndividual.new( EvoSynth::Core::ArrayGenome.new(GENOME_SIZE) { rand(2) > 0 ? true : false } )
		end

		def LocalSearch.print_acceptance_state(algorithm)
			puts "\nAcceptance:" unless algorithm.acceptance.instance_variables.empty?
			algorithm.acceptance.instance_variables.each do |var|
				is_accessor = (var.to_s.gsub("@", "") + "=").to_sym
				puts "\t#{var} = #{algorithm.acceptance.instance_variable_get(var)}" if algorithm.acceptance.respond_to?(is_accessor)
			end
			puts
		end

		def LocalSearch.run_with(profile, individual)
			puts "--- Local Search with #{profile.acceptance.to_s} ---\n"

			profile.individual = individual.deep_clone
			algorithm = EvoSynth::Evolvers::LocalSearch.new(profile)
			LocalSearch.print_acceptance_state(algorithm)

			algorithm.add_observer(EvoSynth::Util::UniversalLogger.new(500, false,
				"generations" => ->{ algorithm.generations_computed },
				"fitness"     => ->{ algorithm.best_solution.fitness },
				"temperature" => ->{ algorithm.acceptance.temperature },
				"alpha"       => ->{ algorithm.acceptance.alpha },
				"delta"       => ->{ algorithm.acceptance.delta }
			))

			result = algorithm.run_until_generations_reached(GENERATIONS)
			LocalSearch.print_acceptance_state(algorithm)

			puts "\n-> fitness after #{GENERATIONS} generations: #{profile.evaluator.calculate_fitness(result)}\n\n"
		end

		profile = EvoSynth::Core::Profile.new(
			:mutation			=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN),
			:evaluator			=> LocalSearchEvaluator.new
		)
		individual = LocalSearch.create_individual

		profile.acceptance = EvoSynth::Evolvers::LocalSearch::HillclimberAcceptance.new
		LocalSearch.run_with(profile, individual)

		profile.acceptance = EvoSynth::Evolvers::LocalSearch::SimulatedAnnealingAcceptance.new(5000.0)
		LocalSearch.run_with(profile, individual)

		profile.acceptance = EvoSynth::Evolvers::LocalSearch::ThresholdAcceptance.new(5000.0)
		LocalSearch.run_with(profile, individual)

		profile.acceptance = EvoSynth::Evolvers::LocalSearch::GreatDelugeAcceptance.new(2500.0)
		LocalSearch.run_with(profile, individual)

		profile.acceptance = EvoSynth::Evolvers::LocalSearch::RecordToRecordTravelAcceptance.new(5000.0)
		LocalSearch.run_with(profile, individual)
	end
end