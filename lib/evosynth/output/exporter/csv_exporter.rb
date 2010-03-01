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


require 'observer'


module EvoSynth
	module Output

		class CSVExporter

			def initialize(logger, write_header = false, separator = ',')
				@logger = logger
				@write_header = write_header
				@separator = separator
			end

			def export(filename)
				# Note: I see no advantage in using the 'csv' library for this

				File.open(filename,  "w+") do |file|
					if @write_header
						file.write("counter")
						file.write(@separator) unless @logger.column_names.nil?
						file.write(@logger.column_names.join(@separator))
						file.write("\n")
					end

					@logger.data.each_key do |key|
						file.write(key)
						file.write(@separator) unless @logger.data[key].nil?
						file.write(@logger.data[key].join(@separator))
						file.write("\n")
					end
				end
			end

		end

	end
end