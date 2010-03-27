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
	module EvoBench

		# diversity calculation of a given population, with a given distance function. (see Weicker, page 62)

		def EvoBench.diversity_distance(population, &distance_function)
			distances = 0.0

			population.each_with_index do |individual, index|
				population[index + 1..population.size].each do |other|
					distances += yield(individual, other)
				end
			end

			1.0 / (population.size * (population.size - 1)) * (distances * 2.0)
		end

		# calls the diversity_distance function with hamming distance block (for binary genomes)

		def EvoBench.diversity_distance_hamming(population)
			EvoBench.diversity_distance(population) do |individual_one, individual_two|
				EvoBench.hamming_distance(individual_one.genome, individual_two.genome)
			end
		end

		# calls the diversity_distance function with hamming distance block (for float genomes)

		def EvoBench.diversity_distance_float(population)
			EvoBench.diversity_distance(population) do |individual_one, individual_two|
				EvoBench.float_distance(individual_one.genome, individual_two.genome)
			end
		end

		# calculates the "hamming distance" (does a bit more) of two given individuals

		def EvoBench.hamming_distance(genome_one, genome_two)
			distance = 0

			genome_one.each_with_index do |gene, index|
				distance += 1 if gene != genome_two[index]
			end

			distance
		end

		# calculates the distance of two given "float individuals"

		def EvoBench.float_distance(genome_one, genome_two)
			distance = 0.0

			genome_one.each_with_index do |gene, index|
				distance += (gene - genome_two[index]).abs
			end

			distance
		end

	end
end
