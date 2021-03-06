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
		# TODO: rdoc

		class Experiment
			include Observable
			
			DEFAULT_EXPERIMENTAL_PLAN = EvoSynth::EvoBench::FullFactorialPlan.new

			attr_accessor :repetitions, :logger
			attr_reader :evolvers, :parameters, :configuration, :experimental_plan

			def initialize(configuration, experimental_plan = DEFAULT_EXPERIMENTAL_PLAN)
				@configuration = configuration
				@experimental_plan = experimental_plan
				@logger = EvoSynth::EvoBench::TestRun::LOGGER_FITNESS_TIME
				@repetitions = 1
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

			def start!
				raise "please set goal block" if @goal_block.nil?
				raise "please set reset block" if @reset_block.nil?

				@experimental_plan.create_plan(self)
				test_runs_computed = 1
				results = []

				@experimental_plan.test_runs do |test_run|
					test_run.set_goal &@goal_block
					test_run.reset_evolvers_with &@reset_block
					test_run.repetitions = @repetitions
					test_run.logger = @logger
					
					results << test_run.start!
				
					changed
					notify_observers self, test_runs_computed, @experimental_plan.number_of_test_runs
					test_runs_computed += 1
				end

				results.flatten
			end

			def to_s
				"Experiment <evolvers=#{@evolvers.to_s}, parameters=#{@parameters.to_s}>"
			end

		end

	end
end
