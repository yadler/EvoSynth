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

		class TSP < EvoSynth::Evaluator
			attr_reader :matrix

			# TODO: refactor and generalize this class, externalize parsing of problem
			# definition file
			# 
			# needs a .tsp file

			def initialize(filename, distance_weight = 2)
				super()
				@distance_weight = distance_weight
				@matrix = read_matrix_from_file(filename)
			end

			def calculate_fitness(individual)
				fitness = 0.0

				individual.genome.each_with_index do |node, index|
					index_two = (index + 1) % individual.genome.size
					fitness += distance(node, individual.genome[index_two])
				end

				fitness
			end

			def distance(from, to)
				@matrix[from, to]
			end

			def size
				@matrix.column_size
			end

			def to_s
				@matrix.to_s
			end

			private

			def read_matrix_from_file(filename)
				nodes = []

				File.open(filename) do |file|
					file.each_line do |line|
						break if line =~ /DISPLAY_DATA_SECTION/
						next if line !~ /^\s*\d+/
						line =~ /(\d+)\s*(\d+.\d+)\s*(\d+.\d+)/

						nodes << line.split.map { |node| node.to_f }
					end
				end

				Matrix.rows(nodes)
			end

		end

	end
end
