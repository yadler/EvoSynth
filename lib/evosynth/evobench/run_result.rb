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

		class RunResult
			attr_accessor :dataset, :evolver, :configuration, :elapsed_time, :repetitions

			def initialize(dataset, evolver, configuration)
				@dataset = dataset
				@evolver = evolver
				@configuration = configuration
				@elapsed_time = 0
				@repetitions = 1
			end

			def marshal_dump
				[ @dataset, @elapsed_time, @repetitions ] #, @configuration, @evolver]
			end

			def marshal_load(variables)
				@dataset = variables[0]
				@elapsed_time = variables[1]
				@repetitions = variables[2]
				# @configuration = variables[3]
				# @evolver = variables[4]
			end

			def RunResult.union(*results)
				datasets = []
				elapsed_time_sum = 0.0
				repetitions_sum = 0.0

				results.each do |result|
					raise "can't merge these RunResults (different configuration!)" if result.configuration != results[0].configuration
					raise "can't merge these RunResults (different evolver!)" if result.evolver != results[0].evolver
					datasets << result.dataset
					elapsed_time_sum += result.elapsed_time
					repetitions_sum += result.repetitions
				end

				union_ds = EvoSynth::Logging::DataSet.union(*datasets)
				union = RunResult.new(union_ds, results[0].evolver, results[0].configuration)
				union.elapsed_time = elapsed_time_sum / results.size

				union
			end

		end

	end
end