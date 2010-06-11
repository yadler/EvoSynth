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

		# TODO: remove me!
		#
		# This class is strange - should be replaced by test_run, experiment und a nice analysis tool!

		class Comparator

			def initialize(repetitions = 1)
				@results = {}
				@evolvers = []
				@repetitions = repetitions

				yield self if block_given?
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
				raise ArgumentError("please set goal block") if @goal_block.nil?
				raise ArgumentError("please set reset block") if @reset_block.nil?

				@evolvers.each do |evolver|
					@results[evolver] = run_evolver(evolver)
				end
			end

			def compare(evolver_one, evolver_two)
				raise "run collect_data! first" if @results[evolver_one].nil? or @results[evolver_two].nil?
				puts "comparison:\n"
				@results[evolver_one].each_pair do |index, results_one|
					results_two = @results[evolver_two][index]
					t_value = EvoSynth::EvoBench.t_test(results_one, results_two)
					error_prob = EvoSynth::EvoBench.t_probability(t_value, @repetitions)

					puts "#{index}\tbest (one) = #{EvoSynth::EvoBench.mean(results_one)}\tbest (two) = #{EvoSynth::EvoBench.mean(results_two)}\tt-value=#{t_value}\terror prob.=#{error_prob}"
				end
			end

			def update(test_run, repetitions_computed)
				print "#{repetitions_computed}..."
			end


			private


			def run_evolver(evolver)

				test_run = EvoSynth::EvoBench::TestRun.new(evolver) do |run|
					run.set_goal &@goal_block
					run.reset_evolvers_with &@reset_block
					run.add_observer(self)
				end

				logger = EvoSynth::Logger.create(1, false, :best_fitness)
				datasets = test_run.start!(@repetitions, logger)
				puts "\n"

				collected_data = {}
				datasets.each do |data|
					data.each_index do |index|
						collected_data[index] = [] unless collected_data.has_key?(index)
						collected_data[index] << data[index, :best_fitness]
					end
				end

				collected_data
			end

		end

	end
end