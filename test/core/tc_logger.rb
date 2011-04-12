require 'shoulda'

require 'evosynth'

class LoggerTest < Test::Unit::TestCase

	context "Simple logger instantiated" do

		setup do
			@logger = EvoSynth::Logger.create(500, true, :gen, :best_fitness, :worst_fitness)
		end

		should "deep_clone return a deep copy" do
			my_clone = @logger.deep_clone
			assert_not_equal(my_clone.object_id, @logger.object_id)
			assert_kind_of(EvoSynth::Logger, my_clone)
			assert(my_clone.save_data)
			assert_not_equal(my_clone.data.object_id, @logger.data.object_id)
			assert_kind_of(EvoSynth::Logging::DataSet, my_clone.data)
			assert_not_equal(my_clone.data_fetcher.object_id, @logger.data_fetcher.object_id)
			assert_kind_of(EvoSynth::Logging::DataFetcher, my_clone.data_fetcher)
			assert_kind_of(Fixnum, my_clone.instance_variable_get(:@log_step))
		end
	end
end