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

		class HTML
			attr_accessor :filename, :title

			def initialize(dataset, filename, title = 'EvoSynth HTML export')
				@dataset = dataset
				@columns = Set.new
				@filename = filename
				@title = title

				yield self if block_given?
				export_all_columns if @columns.empty?

				export
			end

			# to "feel" like gnuplot ;-)
			
			def set_title(title)
				@title = title
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
					file.puts %{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">}
					file.puts %{<html>}
					file.puts %{\t<head>}
					file.puts %{\t\t<title>#{@title}</title>}
					file.puts %{\t\t<meta http-equiv="content-type" content="text/html; charset=UTF-8">}
					file.puts %{\t</head>}
					file.puts %{\t<body>}
					file.puts %{\t\t<table border="1" cellpadding="4" cellspacing="0" align="center">}

					col_indexes = @columns.map { |col|  @dataset.column_names.index(col) }
					table_header = col_indexes.map { |index| @dataset.column_names[index] }

					file.puts %{\t\t\t<thead>}
					file.write("\t\t\t\t<th>#</th>\t")
					file.write("<th>") unless table_header.empty?
					file.write(table_header.join("</th>\t<th>"))
					file.write("</th>\n") unless table_header.empty?
					file.puts %{\t\t\t</thead>}

					file.puts %{\t\t\t<tbody>}
					
					@dataset.each_row_with_index do |row, row_number|
						file.write("\t\t\t\t<tr>\t<td>#{row_number}</td>\t")

						row_to_write = col_indexes.map { |index|  row[index] }
						file.write("<td>") unless row_to_write.empty?
						file.write(row_to_write.join("</td>\t<td>"))
						file.write("</td>") unless row_to_write.empty?

						file.write("\t</tr>\n")
					end

					file.puts %{\t\t\t</tbody>}
					file.puts %{\t\t</table>}
					file.puts %{\t</body>}
					file.puts %{</html>}
				end
			end

		end

	end
end