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
			attr_reader :rows, :cols

			def initialize(rows, columns, initial_data = nil)
				@rows = rows
				@cols = columns
				@data = Array.new(@rows * @cols, initial_data)
			end

			def [](row, col)
				@data[row * @cols + col]
			end

			def []=(row, col, data)
				@data[row * @cols + col] = data
			end

			def row_to_a(row)
				@data[(row * @cols)..(row * @cols + @cols - 1)]
			end

			def col_to_a(col)
				column = []
				@rows.times { |row| column << @data[@rows * row + col] }
				column
			end

			def each
				@rows.times do	|row|
					@cols.times do |col|
						yield @data[row * @cols + col]
					end
				end
			end

			def each_index
				@rows.times do	|row|
					@cols.times do |col|
						yield row, col
					end
				end
			end

			def each_with_index
				@rows.times do	|row|
					@cols.times do |col|
						yield @data[row * @cols + col], row, col
					end
				end
			end

			def each_row
				@rows.times do	|row|
					row_data = []

					@cols.times do |col|
						row_data << @data[row * @cols + col]
					end

					yield row_data, row
				end
			end

			def dimensions
				[@rows, @cols]
			end

			def to_s
				@data.to_s
			end

		end

	end

end