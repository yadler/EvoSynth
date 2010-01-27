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
	module Util

		# Customizable logger
		#
		#	algorithm.add_observer(EvoSynth::Util::UniversalLogger.new(500,
		#		algorithm => :generations_computed,
		#		profile.individual => :fitness,
		#		profile.acceptance => [:temperature, :alpha, :delta]
		#	))

		class UniversalLogger
			attr_accessor :things_to_log

			LOG_TO_CONSOLE = lambda { |line| puts "#{line.join("\t")}"}
			DEFAULT_LOG_TARGET = LOG_TO_CONSOLE

			def initialize(print_generation_step, show_errors, things_to_log = {}, log_target = DEFAULT_LOG_TARGET)
				@print_generation_step = print_generation_step
				@things_to_log = things_to_log
				@show_errors = show_errors
				@log_target = log_target
			end

			def column_names
				line = []
				@things_to_log.each_pair { |key, value|	line << key }
				line
			end

			def update(generations_computed, algorithm)
				return unless generations_computed % @print_generation_step == 0

				line = []
				@things_to_log.each_pair do |key, value|
					begin
						line << value.call
					rescue
						@show_errors ? line << "ERROR while retrieving #{value.inspect}" : line << "\t"
					end
				end

				@log_target.call(line)
			end

		end

	end
end