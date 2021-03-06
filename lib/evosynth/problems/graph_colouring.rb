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


require 'matrix'


module EvoSynth
	module Problems

		class GraphColouring < EvoSynth::Evaluator

			attr_reader :node_count
			attr_reader :matrix

			def initialize(filename)
				super()
				read_file(filename)
			end

			def verletzungen(genome)
				verletzungen = 0

				@node_count.times do |row|
					@node_count.times do |col|
						verletzungen += 1 if @matrix[row, col] == 1 && genome[row] == genome[col]
					end
				end

				verletzungen
			end

			def calculate_fitness(individual)
				fitness = 0.0 + individual.genome.uniq.size * (verletzungen(individual.genome) + 1)
				fitness
			end

			private

			# reads the node count from grapg-file
			def get_node_count(file_name)
				File.open(file_name).each_line do |line|
					next if line !~ /^p\D*(\d+)/
					return Integer($1)
				end
			end

			# reads a graph file
			def read_file(file_name)
				@node_count = get_node_count(file_name)
				@matrix = Matrix.zero(@node_count)

				columns = @matrix.column_vectors


				File.open(file_name).each_line do |line|
					next if line !~ /^e/
					line =~ /(\d+)\s*(\d+)/
					arr = columns[Integer($1)-1].to_a
					arr[Integer($2)-1] = 1
					columns[Integer($1)-1] = Vector.elements(arr)
				end
				@matrix = Matrix.columns(columns)
			end

		end

	end
end