require 'shoulda'

require 'evosynth'

class IndividualTest < Test::Unit::TestCase

	class MyEvaluator < EvoSynth::Evaluator
		def calculate_fitness(individual)
			individual.genome.inject(0.0) { |fitness, gene| fitness += gene ? 1 : 0 }
		end
	end

	context "GeneticAlgorithm instantiated with a configuration" do

		setup do
			configuration = EvoSynth::Configuration.new do |conf|
				conf.evaluator	= MyEvaluator.new
				conf.mutation	= EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
				conf.population	= EvoSynth::Population.new(20) { EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(64) { EvoSynth.rand_bool } ) }
			end
			@evolver = EvoSynth::Evolvers::GeneticAlgorithm.new(configuration)
		end

		should "deep_clone return a deep copy" do
			my_clone = @evolver.deep_clone
			assert_not_equal my_clone.object_id, @evolver.object_id
			assert_not_equal my_clone.evaluator.object_id, @evolver.evaluator.object_id
			assert_not_equal my_clone.mutation.object_id, @evolver.mutation.object_id
			assert_not_equal my_clone.mutation.object_id, @evolver.configuration.mutation.object_id
			assert_not_equal my_clone.configuration.object_id, @evolver.configuration.object_id
			assert_kind_of MyEvaluator, my_clone.evaluator
			assert_kind_of EvoSynth::Mutations::BinaryMutation, my_clone.mutation
			assert_kind_of EvoSynth::Configuration, my_clone.configuration
		end
	end

		context "GeneticAlgorithm instantiated with a block-invocation" do

		setup do
			@evolver = EvoSynth::Evolvers::GeneticAlgorithm.new do |ga|
				ga.evaluator	= MyEvaluator.new
				ga.mutation	= EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
				ga.population	= EvoSynth::Population.new(20) { EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(64) { EvoSynth.rand_bool } ) }
			end
		end

		should "deep_clone return a deep copy" do
			my_clone = @evolver.deep_clone
			assert_not_equal my_clone.object_id, @evolver.object_id
			assert_not_equal my_clone.evaluator.object_id, @evolver.evaluator.object_id
			assert_not_equal my_clone.mutation.object_id, @evolver.mutation.object_id
			assert_not_equal my_clone.mutation.object_id, @evolver.configuration.mutation.object_id
			assert_not_equal my_clone.configuration.object_id, @evolver.configuration.object_id
			assert_kind_of MyEvaluator, my_clone.evaluator
			assert_kind_of EvoSynth::Mutations::BinaryMutation, my_clone.mutation
			assert_kind_of EvoSynth::Configuration, my_clone.configuration
		end
	end


end