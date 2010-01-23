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
	module Algorithms

		# based on CCGA-1/2 (Mitchell A. Potter and Kenneth A. De Jong)

		class CoopCoevolutionary
			include EvoSynth::Algorithms::Algorithm

			def initialize(profile)
				init_profile :mutation, :selection, :recombination, :populations, :fitness_calculator, :recombination_probability => 0.75,
					:sub_algorithm => EvoSynth::Algorithms::ElitismGeneticAlgorithm
				use_profile profile

				initialize_sub_algorithms(profile)
				@next_index = 0
			end

			def to_s
				"CCGA-1 <mutation: #{@mutation}, selection: #{@selection}, recombination: #{@recombination}>"
			end

			def best_solution
				best = []
				@populations.each { |pop| best << pop.best.fitness }
				best.to_s
			end

			def worst_solution
				worst = []
				@populations.each { |pop| worst << pop.worst.fitness }
				worst.to_s
			end

			def return_result
				best = []
				@populations.each { |pop| best << pop.best.fitness }
				best
			end

			def next_generation
				@algorithms[@next_index].next_generation
				@next_index = (@next_index + 1) % @populations.size
			end

			private

			def get_sub_profile(profile)
				sub_profile = Struct.new(:mutation, :selection, :recombination, :population, :fitness_calculator, :recombination_probability).new
				sub_profile.mutation = profile.mutation
				sub_profile.selection = profile.selection
				sub_profile.recombination = profile.recombination
				sub_profile.fitness_calculator = profile.fitness_calculator
				sub_profile.recombination_probability = profile.recombination_probability
				sub_profile
			end

			def initialize_sub_algorithms(profile)
				sub_profile = get_sub_profile(profile)

				@algorithms = []
				@populations.each do |sub_population|
					sub_profile.population = sub_population
					@algorithms << @sub_algorithm.new(sub_profile)
				end
			end

		end

	end
end