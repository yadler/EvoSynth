require 'shoulda'

require 'evosynth'

class DataFetcherTest < Test::Unit::TestCase

	context "Simple datafetcher instantiated" do

		setup do
			@data_fetcher = EvoSynth::Logging::DataFetcher.new
			@data_fetcher.add_column(:strlambda, -> {"foo"})
			@data_fetcher.add_column(:intlambda, -> {42})
		end

		should "deep_clone return a deep copy" do
			my_clone = @data_fetcher.deep_clone
			assert_not_equal(my_clone.object_id, @data_fetcher.object_id)
			assert_kind_of(EvoSynth::Logging::DataFetcher, my_clone)
			assert !@data_fetcher.show_fetch_errors
			assert_not_equal(my_clone.columns.object_id, @data_fetcher.columns.object_id)
			assert_kind_of(Hash, my_clone.columns)
			my_clone.columns.each do |key, value|
				assert_not_equal(my_clone.columns[key].object_id, @data_fetcher.columns[key].object_id)
				assert_kind_of(Proc, @data_fetcher.columns[key])
			end
		end
	end
end