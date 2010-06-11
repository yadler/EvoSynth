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

		class TestRun
			include Observable

			attr_reader :runs_computed

			DEFAULT_LOGGER = EvoSynth::Logger.create(1, false, :best_fitness)


			# Initialize a Test-Run for the given evolver. Optional: use the given Configuration.

			def initialize(evolver, configuration = nil)
				@evolver = evolver
				@runs_computed = 0
				@goal_block = nil
				@reset_block = nil

				unless configuration.nil?
					@configuration = configuration
					@evolver.use_configuration(configuration)
				end

				yield self if block_given?
			end

			def set_goal(&goal_block)
				@goal_block = goal_block
			end

			def reset_evolvers_with(&reset_block)
				@reset_block = reset_block
			end

			def start!(repetitions = 1, logger = DEFAULT_LOGGER)
				raise "please set goal block" if @goal_block.nil?
				raise "please set reset block" if @reset_block.nil?

				data_sets = []
				@runs_computed = 0
				@evolver.add_observer(logger)

				repetitions.times do |run|
					# reset all relevant objects
					@reset_block.call @evolver
					logger.clear_data!
					
					@evolver.run_until { |evolver| @goal_block.call evolver }
					data_sets << logger.data

					@runs_computed += 1
					changed
					notify_observers self, @runs_computed
				end

				@evolver.delete_observer(logger)
				data_sets
			end

		end

	end
end