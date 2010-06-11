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

		class Experiment
			attr_reader :evolvers, :parameters, :configuration

			def initialize(configuration)
				@configuration = configuration
				@evolvers = []
				@parameters = {}
				yield self
			end

			def set_goal(&goal_block)
				@goal_block = goal_block
			end

			def reset_evolver_with(&reset_block)
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

			def create_experiment_plan
				plan = []
				configurations = []

				@parameters.each_key do |param_type|

					@parameters[param_type].each do |parameter|


						@parameters.each_key do |inner_param_type|
							next if inner_param_type == param_type

							puts @parameters[inner_param_type].zip( [parameter] * @parameters[inner_param_type].size).to_s
							# TODO: FIXME!!!
						end

#						puts foo.to_s
					end
				end
#				puts configurations.to_s
			end

			def start!
				experiments = create_experiment_plan

				experiments.each do |configuration|
					@evolver.reset!(configuration)
					puts "I would run #{@evolver} with #{configuration}"

#					EvoSynth::EvoBench::TestRun.new(@evolver) do |run|
#						run.set_goal &@goal_block
#						run.reset_evolvers_with &@reset_block
#						run.start!
#					end
				end
			end

			def to_s
				"Experiment <evolver=#{@evolver}, parameters=#{@parameters.to_s}>"
			end

		end

	end
end
