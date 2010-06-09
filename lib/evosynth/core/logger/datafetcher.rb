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
	module Logging

		class DataFetcher
			attr_accessor :show_fetch_errors
			attr_reader :columns

			def initialize(show_fetch_errors = false)
				@columns, @data = {}, {}
				@show_fetch_errors = show_fetch_errors
			end

			def add_column(name, column_lambda)
				@columns[name] = column_lambda
			end

			def fetch_next_row(observable)
				row = []

				@columns.each_pair do |column_name, column_lambda|
					begin
						row << column_lambda.call(observable)
					rescue
						if @show_fetch_errors
							row << "Error while fetching '#{column_name}'"
						else
							row << nil
						end
					end
				end

				row
			end

		end

	end
end