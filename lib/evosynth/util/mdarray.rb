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

		# Simple multidimensional Array

		class MDArray

			def initialize(rows, columns, initial_data = nil)
				@row_count = rows
				@col_count = columns
				@data = Array.new(@row_count * @col_count, initial_data)
			end

			def [](row, col)
				@data[row * @col_count + col]
			end

			def []=(row, col, data)
				@data[row * @col_count + col] = data
			end

			def each_index
				@row_count.times do	|row|
					@col_count.times do |col|
						yield row, col
					end
				end
			end

			def each_with_index
				@row_count.times do	|row|
					@col_count.times do |col|
						yield @data[row * @col_count + col], row, col
					end
				end
			end

			def each_row
				@row_count.times do	|row|
					row_data = []

					@col_count.times do |col|
						row_data << @data[row * @col_count + col]
					end

					yield row_data
				end
			end

			def to_s
				@data.to_s
			end

		end

	end

end