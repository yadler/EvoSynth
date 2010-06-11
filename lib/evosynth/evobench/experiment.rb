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

		# versuchsreihen mit:
		#
		#-> verschiedene "Benchmarkfunktionen", also verschiedene Fitnessfunktionen
		#   für alle zu testenden Operatoren
		#-> array von mutationen, selektionen, rekombination, evolvern, ...
		#-> verschiedene randomgeneratoren testen
		#-> range mit schrittweite für parameter (Integer und Float)
		#-> array mit werten für alles andere?

		# TODO: arrays und ranges für parameter!

		class Experiment
			DEFAULT_EXPERIMENTAL_PLAN = EvoSynth::EvoBench::FullFactorialPlan.new

			attr_reader :evolvers, :parameters, :configuration, :experimental_plan

			def initialize(configuration, experimental_plan = DEFAULT_EXPERIMENTAL_PLAN)
				@configuration = configuration
				@experimental_plan = experimental_plan
				@evolvers = []
				@parameters = {}
				yield self
			end

			def set_goal(&goal_block)
				@goal_block = goal_block
			end

			def reset_evolvers_with(&reset_block)
				@reset_block = reset_block
			end

			def try_evolver(evolver)
				@evolvers << evolver
			end

			def try_parameter(parameter, value)
				if @parameters.has_key?(parameter)
					@parameters[parameter] << value
				else
					@parameters[parameter] = [value]
				end
			end

			def start!(repetitions = 1, logger = EvoSynth::EvoBench::TestRun::LOGGER_FITNESS_TIME)
				runs = @experimental_plan.create_runs(self)
				test_counter = 1
				results = []

				runs.each do |test_run|
					test_run.set_goal &@goal_block
					test_run.reset_evolvers_with &@reset_block
					
					puts "running test #{test_counter} of #{runs.size}..."
					results << test_run.start!(repetitions, logger)
					test_counter += 1
				end

				results
			end

			def to_s
				"Experiment <evolvers=#{@evolvers.to_s}, parameters=#{@parameters.to_s}>"
			end

		end

	end
end
