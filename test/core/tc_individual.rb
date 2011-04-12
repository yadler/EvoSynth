require 'shoulda'

require 'evosynth'

class IndividualTest < Test::Unit::TestCase

	context "genome has no fixed object_id like fixnum" do
		context "initialized with MaximizingIndividual" do
			setup do
				@individual = EvoSynth::MaximizingIndividual.new(EvoSynth::BinaryGenome.new)
			end

			should "deep_clone makes a deep copy" do
				my_clone = @individual.deep_clone
				assert_not_equal my_clone.genome.object_id, @individual.genome.object_id
				assert_equal my_clone.fitness, @individual.fitness
				my_clone.fitness = 1.4
				assert_not_equal my_clone.fitness, @individual.fitness
				assert_nothing_raised {my_clone.compare_fitness_values(1, 2)}
			end
			
		end

		context "initialized with MinimizingIndividual" do
			setup do
				@individual = EvoSynth::MinimizingIndividual.new(EvoSynth::BinaryGenome.new)
			end
			
			should "deep_clone makes a deep copy" do
				my_clone = @individual.deep_clone
				assert_not_equal my_clone.genome.object_id, @individual.genome.object_id
				assert_equal my_clone.fitness, @individual.fitness
				my_clone.fitness = 1.4
				assert_not_equal my_clone.fitness, @individual.fitness
				assert_nothing_raised {my_clone.compare_fitness_values(1, 2)}
			end
		end
	end
end