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

		class FullFactorialPlan

			def create_runs(experiment)
				runs = []

				combinations = parameter_combinations(experiment.parameters)

				experiment.evolvers.each do |evolver|

					if combinations.empty?
						runs << EvoSynth::EvoBench::TestRun.new(evolver, experiment.configuration)
					else
						combinations.each do |combination|
							combi_conf = experiment.configuration.clone
							combination.each { |param| combi_conf.send("#{param[0]}=", param[1]) }
							runs << EvoSynth::EvoBench::TestRun.new(evolver, combi_conf)
						end
					end

				end

				runs
			end

			def parameter_combinations(parameters)
				combinations = []

				parameters.keys.each do |parameter_type|				
					if combinations.empty?
						parameters[parameter_type].each { |param| combinations << [[parameter_type, param]] }
					else
						new_combs = []
						combinations.each do |combination|
							parameters[parameter_type].each do |param|
								new_combs << combination + [[parameter_type, param]]
							end
						end

						combinations = new_combs
					end
				end

				combinations
			end


			
		end

	end
end