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

	module Selections

		# Q-STUFIGE-TURNIER-SELEKTION (Weicker Page 69)

		class NStageTournamentSelection

			attr_accessor :stages

			DEFAULT_STAGES = 2

			def initialize(stages = DEFAULT_STAGES)
				@stages = stages
			end

			#Return a deep copy of this operator

			def deep_clone
				self.clone
			end

			def select(population, select_count = 1)
				selected_population = EvoSynth::Population.new

				scores = calculate_scores(population)
				scores = scores.sort { |first, second| first[0] <=> second[0] * -1 }
				scores.first(select_count).each { |winner| selected_population.add(winner[1]) }

				selected_population
			end

			def to_s
				"n-stage tournament selection <stages: #{@stages}>"
			end

			private

			def calculate_scores(population)
				scores = []

				population.each do |individual|
					victories = fight(population, individual)
					scores << [victories, individual]
				end

				scores
			end

			def fight(population, individual)
				victories = 0

				@stages.times do
					enemy = population[EvoSynth.rand(population.size)]
					victories += 1 if individual > enemy
				end

				victories
			end

		end

	end

end

