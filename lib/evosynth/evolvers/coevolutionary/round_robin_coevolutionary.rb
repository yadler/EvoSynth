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
	module Evolvers

		# based on CCGA-1/2 (Mitchell A. Potter and Kenneth A. De Jong)

		class RoundRobinCoevolutionary < EvoSynth::Evolver

			attr_reader :subevolvers

			DEFAULT_SUBEVOLVERS_CREATOR = ->(configuration) { evolver = EvoSynth::Evolvers::GeneticAlgorithm.new(configuration);
			                                                  EvoSynth::Evolvers.add_weak_elistism(evolver);
			                                                  evolver }

			def required_configuration?
				{
					:populations			=> REQUIRED_FIELD,
				    :subevolvers_creator	=> DEFAULT_SUBEVOLVERS_CREATOR
				}
			end

			def setup
				initialize_sub_evolvers(@configuration)
				@next_index = 0
			end

			def to_s
				"cooperative coevolutionary algorithm"
			end

			def best_solution
				best = []
				@populations.each { |pop| best << pop.best }
				best
			end

			def worst_solution
				worst = []
				@populations.each { |pop| worst << pop.worst }
				worst
			end

			def return_result
				@populations
			end

			def next_generation
				@subevolvers[@next_index].next_generation
				@next_index = (@next_index + 1) % @populations.size
			end

			private

			def initialize_sub_evolvers(configuration)
				sub_configuration = configuration.clone

				@subevolvers = []
				@populations.each do |sub_population|
					sub_configuration.population = sub_population
					@subevolvers << @subevolvers_creator.call(sub_configuration)
				end
			end

		end

	end
end