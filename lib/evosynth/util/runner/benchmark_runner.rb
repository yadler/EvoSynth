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

		def Util.run_algorith_with_benchmark(algorithm_class, profile, generations = 1, &condition)
			require 'benchmark'

			algorithm = algorithm_class.new(profile)
			result = nil

			puts "Running #{algorithm}..."
			if block_given?
				timing = Benchmark.measure { result = algorithm.run_until(&condition) }
			else
				timing = Benchmark.measure { result = algorithm.run_until_generations_reached(generations) }
			end

			puts "\tevolved #{algorithm.generations_run} generations, this took: #{timing}"
			puts "\tresult:"
			puts "\t\tindividual      : #{result}" if defined? result.calculate_fitness
			puts "\t\tbest individual : #{result.best}" if defined? result.best
			puts "\t\tworst individual: #{result.worst}" if defined? result.worst
			puts
		end

	end
end