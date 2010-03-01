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
	module Output

		# Customizable logger
		#
		#	logger = EvoSynth::Output::Logger.new(10, true,
		#		"gen" => ->{ evolver.generations_computed },
		#		"best" => ->{ profile.population.best.fitness },
		#		"worst" => ->{ profile.population.worst.fitness }
		#	)
		#	evolver.add_observer(logger)

		class Logger
			include Observable

			attr_accessor :show_errors, :things_to_log, :save_data
			attr_reader :data

			def initialize(log_step, save_data, things_to_log = {})
				@data = {}

				@log_step = log_step
				@save_data = save_data
				@things_to_log = things_to_log
				@show_errors = false
			end

			def clear_data
				@data = {}
			end

			def column_names
				line = []
				@things_to_log.each_pair { |key, value|	line << key }
				line
			end

			def update(observable, counter)
				return unless counter % @log_step == 0

				line = []
				@things_to_log.each_pair do |key, value|
					begin
						line << value.call
					rescue
						@show_errors ? line << "ERROR while retrieving #{value.inspect}" : line << "\t"
					end
				end

				@data[counter] = line if save_data

				changed
				notify_observers self, counter, line
			end

		end

	end
end