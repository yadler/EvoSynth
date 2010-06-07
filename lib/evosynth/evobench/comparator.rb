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

		class Comparator

			def initialize(repetitions = 1)
				@results = {}
				@evolvers = []
				@repetitions = repetitions
			end

			def set_goal(&goal_block)
				@goal_block = goal_block
			end

			def reset_evolvers_with(&reset_block)
				@reset_block = reset_block
			end

			def add_evolver(evolver)
				@evolvers << evolver
			end

			def collect_data!
				@evolvers.each do |evolver|
					@results[evolver] = run_evolver(evolver)
				end
			end

			def compare(evolver_one, evolver_two)
				puts "comparison:\n"
				@results[evolver_one].each_pair do |index, results_one|
					results_two = @results[evolver_two][index]
					t_value = EvoSynth::EvoBench.t_test(results_one, results_two)
					error_prob = EvoSynth::EvoBench.t_probability(t_value, @repetitions)

					puts "#{index}\tbest (one) = #{EvoSynth::EvoBench.mean(results_one)}\tbest (two) = #{EvoSynth::EvoBench.mean(results_two)}\tt-value=#{t_value}\terror prob.=#{error_prob}"
				end
			end


			private


			# TODO: add some sort of progress counter here
			def run_evolver(evolver)
				collected_data = {}

				logger = EvoSynth::Logger.new(1) do |log|
					log.add_column("best fitness", ->{ evolver.best_solution?.fitness })
				end
				evolver.add_observer(logger)

				@repetitions.times do |run|
					# reset all relevant objects
					@reset_block.call evolver
					logger.clear_data!

					print "."
					evolver.run_until { |gen, best| @goal_block.call gen, best }

					logger.data.each_row_with_index do |row, index|
						collected_data[index] = [] unless collected_data.has_key?(index)
						collected_data[index] << row[0] # best fitness
					end
				end
				puts "\n"

				evolver.delete_observer(logger)
				collected_data
			end

		end

	end
end