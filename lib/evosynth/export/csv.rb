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


require 'set'


module EvoSynth
	module Export

		class CSV
			attr_accessor :filename, :write_header, :separator

			def initialize(dataset, filename, write_header = false, separator = ',')
				@dataset = dataset
				@columns = Set.new
				@filename = filename
				@write_header = write_header
				@separator = separator
				
				yield self if block_given?
				export_all_columns if @columns.empty?
				
				export
			end

			def export_column(name)
				raise "column '#{name}' not in dataset" if @dataset.column_names.index(name).nil?
				@columns << name
			end

			def export_all_columns
				@dataset.column_names.each { |name| export_column(name) }
			end

			private

			def export
				File.open(@filename,  "w+") do |file|
					if @write_header
						file.write("counter")
						file.write(@separator) unless @columns.nil? or @columns.empty?
						file.write(@columns.to_a.join(@separator))
						file.write("\n")
					end

					col_indexes = @columns.map { |col|  @dataset.column_names.index(col) }

					@dataset.each_row_with_index do |row, row_number|
						file.write(row_number)
						file.write(@separator) unless row.nil?

						row_to_write = col_indexes.map { |index|  row[index] }
						file.write(row_to_write.join(@separator))

						file.write("\n")
					end
				end
			end

		end

	end
end