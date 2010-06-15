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

		class LocalSearchEvaluator < EvoSynth::Evaluator

			def decode(individual)
				values = []
				DIMENSIONS.times do |dim|
					values << EvoSynth::Decoder.binary_to_real(individual.genome[dim * VALUE_BITS, VALUE_BITS], LOWER_LIMIT, UPPER_LIMIT)
				end
				values
			end

			def calculate_fitness(individual)
				EvoSynth::Problems::FloatBenchmarkFuntions.sphere(decode(individual))
			end
		end

		def LocalSearch.create_individual
			EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new(GENOME_SIZE) { EvoSynth.rand_bool } )
		end

		def LocalSearch.print_acceptance_state(evolver)
			puts "\nAcceptance:" unless evolver.acceptance.instance_variables.empty?
			evolver.acceptance.instance_variables.each do |var|
				is_accessor = (var.to_s.gsub("@", "") + "=").to_sym
				puts "\t#{var} = #{evolver.acceptance.instance_variable_get(var)}" if evolver.acceptance.respond_to?(is_accessor)
			end
			puts
		end

		def LocalSearch.run_with(configuration, individual)
			puts "--- Local Search with #{configuration.acceptance.to_s} ---\n"

			configuration.individual = individual.deep_clone
			evolver = EvoSynth::Evolvers::LocalSearch.new(configuration)
			LocalSearch.print_acceptance_state(evolver)

			logger = EvoSynth::Logger.create(500, true, :gen, :best_fitness) do |log|
				log.add_column("temperature",  ->(evolver) { evolver.acceptance.temperature })
				log.add_column("alpha",        ->(evolver) { evolver.acceptance.alpha })
				log.add_column("delta",        ->(evolver) { evolver.acceptance.delta })
			end
			evolver.add_observer(logger)

			result = evolver.run_until_generations_reached(GENERATIONS)
			LocalSearch.print_acceptance_state(evolver)

			puts "\n-> fitness after #{GENERATIONS} generations: #{configuration.evaluator.calculate_fitness(result)}\n\n"
		end

		configuration = EvoSynth::Configuration.new(
			:mutation			=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN),
			:evaluator			=> LocalSearchEvaluator.new
		)
		individual = LocalSearch.create_individual

		configuration.acceptance = EvoSynth::Evolvers::LocalSearch::HillclimberAcceptance.new
		LocalSearch.run_with(configuration, individual)

		configuration.acceptance = EvoSynth::Evolvers::LocalSearch::SimulatedAnnealingAcceptance.new(5000.0)
		LocalSearch.run_with(configuration, individual)

		configuration.acceptance = EvoSynth::Evolvers::LocalSearch::ThresholdAcceptance.new(5000.0)
		LocalSearch.run_with(configuration, individual)

		configuration.acceptance = EvoSynth::Evolvers::LocalSearch::GreatDelugeAcceptance.new(2500.0)
		LocalSearch.run_with(configuration, individual)

		configuration.acceptance = EvoSynth::Evolvers::LocalSearch::RecordToRecordTravelAcceptance.new(5000.0)
		LocalSearch.run_with(configuration, individual)
	end
end