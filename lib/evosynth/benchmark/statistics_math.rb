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
	module Benchmark

		# calculates the mean of an array. if a block is given it will yield each item
		# and add the result of the block instead of the item itself
		#
		# EvoSynth::Benchmark::Benchmark.mean(@population) { |individual| individual.fitness }

		def Benchmark.mean(array)
			1.0/array.size * array.inject(0.0) do |sum, item|
				if block_given?
					value = yield item
				else
					value = item
				end

				sum += value
			end
		end

		# shortcut for: EvoSynth::Benchmark::Benchmark.mean(@population) { |individual| individual.fitness }

		def Benchmark.population_fitness_mean(population)
			Benchmark.mean(population) { |individual| individual.fitness }
		end

		# calculates the median of an array. if a block is given it will yield each item
		# and add the result of the block instead of the item itself
		#
		# EvoSynth::Benchmark::Benchmark.median(@population) { |individual| individual.fitness }

		def Benchmark.median(array)
			array.sort!
			if array.size % 2 == 0
				if block_given?
					0.5 * ((yield array[array.size/2]) + (yield array[array.size/2 - 1]))
				else
					0.5 * (array[array.size/2] + array[array.size/2 - 1])
				end
			else
				if block_given?
					yield array[array.size / 2]
				else
					array[array.size / 2]
				end
			end
		end

		# shortcut for: EvoSynth::Benchmark::Benchmark.median(@population) { |individual| individual.fitness }

		def Benchmark.population_fitness_median(population)
			Benchmark.median(population) { |individual| individual.fitness }
		end

		# calculates the variance of an array. if a block is given it will yield each item
		# and add the result of the block instead of the item itself
		#
		# EvoSynth::Benchmark::Benchmark.variance(@population, mean) { |individual| individual.fitness }

		def Benchmark.variance(array, mean)
			if block_given?
				1.0 / (array.size - 1.0) * array.inject(0.0) { |sum, x| sum += ((yield x) - mean) ** 2.0 }
			else
				1.0 / (array.size - 1.0) * array.inject(0.0) { |sum, x| sum += (x - mean) ** 2.0 }
			end
		end

		# shortcut for:
		#			mean = Benchmark.population_fitness_mean(population)
		#			Benchmark.variance(population, mean) { |individual| individual.fitness }

		def Benchmark.population_fitness_variance(population)
			mean = Benchmark.population_fitness_mean(population)
			Benchmark.variance(population, mean) { |individual| individual.fitness }
		end

		# TODO: improve me, make me more useful for populations :)

		def Benchmark.standard_deviation(variance)
			Math.sqrt(variance)
		end

	end
end