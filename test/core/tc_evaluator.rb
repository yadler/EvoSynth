require 'shoulda'

require 'evosynth'

class EvaluatorTest < Test::Unit::TestCase

	context "an evaluator with additional instance variable with non fixed object_id" do
		class MyEvaluator < EvoSynth::Evaluator
			def initialize
				@testvar = "abc"
			end
			
			def calculate_fitness(individual)
				individual.genome.inject(0.0) { |fitness, gene| fitness += gene ? 1 : 0 }
			end
		end

		setup do
			@evaluator = MyEvaluator.new
		end

		should "deep_clone returns a deep copy" do
			my_clone = @evaluator.deep_clone
			assert_not_equal my_clone.object_id, @evaluator.object_id
			assert_not_equal @evaluator.instance_variable_get("@testvar").object_id,
												my_clone.instance_variable_get("@testvar").object_id
		end

	end

end