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


require 'evosynth/core/logger/dataset'
require 'evosynth/core/logger/datafetcher'


module EvoSynth

	# customizable (column based) logger
	#
	#	logger = EvoSynth::Output::Logger.new(10, true,
	#		"gen" => ->{ evolver.generations_computed },
	#		"best" => ->{ configuration.population.best.fitness },
	#		"worst" => ->{ configuration.population.worst.fitness }
	#	)
	#	evolver.add_observer(logger)

	class Logger
		include Observable

		attr_accessor :save_data
		attr_reader :data, :data_fetcher

		def initialize(log_step, save_data = true, things_to_log = {})
			@log_step = log_step
			@save_data = save_data
			@data_fetcher = EvoSynth::Logging::DataFetcher.new
			@data = EvoSynth::Logging::DataSet.new

			things_to_log.each_pair  { |name, lambda| add_column(name, lambda) }

			yield self if block_given?
		end

		def add_column(column_name, column_lambda)
			@data_fetcher.add_column(column_name, column_lambda)
				@data.column_names << column_name
		end

		def clear_data!
			@data = EvoSynth::Logging::DataSet.new(@data.column_names)
		end

		def update(observable, counter)
			return unless counter % @log_step == 0

			new_row = @data_fetcher.fetch_next_row(counter)
			@data[counter] = new_row if @save_data

			changed
			notify_observers self, counter, new_row
		end

	end

end