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

		class DataSet
			attr_accessor :column_names

			def initialize(column_names = [])
				@data = {}
				@column_names = column_names
			end

			def [](row_number, column_name = nil)
				if column_name.nil?
					@data[row_number]
				else
					col_index = @column_names.index(column_name)
					raise "unknown column '#{column_name}'" if col_index.nil?
					@data[row_number][col_index]
				end
			end

			def []=(row_number, row)
				@data[row_number] = row
			end

			def has_row?(row_num)
				@data.has_key?(row_num)
			end

			def each_index
				@data.keys.each { |row_num| yield row_num }
			end

			def each_row
				@data.each { |row_num, row| yield row }
			end

			def each_row_with_index
				@data.each { |row_num, row| yield row, row_num }
			end

			def DataSet.union(*datasets)
				union = DataSet.new(datasets[0].column_names)

				datasets.each do |dataset|
					raise "can't merge these DataSets (different columns!)" if union.column_names != dataset.column_names

					dataset.each_row_with_index do |row, index|
						union[index] = [] unless union.has_row?(index)

						dataset[index].each_with_index do |data, col_index|
							union[index][col_index] = [] if union[index][col_index].nil?
							union[index][col_index] << data
						end
					end
				end

				union
			end
		end

	end
end