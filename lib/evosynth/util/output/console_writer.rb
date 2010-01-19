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

		class ConsoleWriter

			def initialize(print_gen_step = 10, verbose = true)
				@print_generation_step = print_gen_step
				@verbose = verbose
			end

			def update(generations_run, algorithm)
				if generations_run % @print_generation_step == 0
					best = "no best individual could be retrieved"
					worst = "no worst individual could be retrieved"

					if defined? algorithm.population
						best = @verbose ? algorithm.population.best : algorithm.population.best.fitness
						worst = @verbose ? algorithm.population.worst : algorithm.population.worst.fitness
					elsif defined? algorithm.individual
						best = @verbose ? algorithm.individual : algorithm.individual.fitness
						worst = @verbose ? algorithm.individual : algorithm.individual.fitness
					end

					puts "#{generations_run}\t#{best}\t#{worst}"
				end
			end

		end

	end
end