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

		# TURNIER-SELEKTION (Weicker Page 76)

		class TournamentSelection

			attr_accessor :enemies

			DEFAULT_ENEMIES = 2

			def initialize(enemies = DEFAULT_ENEMIES)
				@enemies = enemies
			end

			def select(population, select_count = 1)
				selected_population = EvoSynth::Core::Population.new

				select_count.times do
					individual = fight(population, population[EvoSynth.rand(population.size)])
					selected_population.add(individual)
				end

				selected_population
			end

			def to_s
				"tournament selection <enemies: #{@enemies}>"
			end

			private

			def fight(population, individual)
				@enemies.times do
					enemy = population[EvoSynth.rand(population.size)]
					individual = enemy if enemy > individual
				end

				individual
			end

		end

	end

end