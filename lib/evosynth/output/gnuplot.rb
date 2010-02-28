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

		def Output.draw_with_gnuplot(logger, title)
			require 'gnuplot'

			Gnuplot.open do |gp|
				Gnuplot::Plot.new( gp ) do |plot|

					plot.title  title
#					plot.ylabel "fitness"
#					plot.xlabel "generation"

					x, ys = [], []
					data_sets = 0
					logger.data.each_pair do |key, value|
						data_sets = value.size if value.size > data_sets
						x << key						
						value.each_with_index do |y, index|
							ys[index] = [] if ys[index].nil?
							ys[index] << y
						end
					end

					data_sets.times do |set|
						plot.data << Gnuplot::DataSet.new( [x, ys[set]] ) do |ds|
							ds.with = "lines"
							ds.title = logger.column_names[set]
						end
					end
				end
			end
		end

	end
end