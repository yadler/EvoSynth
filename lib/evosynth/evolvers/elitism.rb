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

		# FIXME: change these to use best solution or not?


		# this function adds weak elistism to a evolver using instance_eval
		#
		# weak elitism: if fitness of childrens decreased, replace worst individual with best parent

		def Evolvers.add_weak_elistism(evolver)
			evolver.population rescue raise "Evolver not supported!"

			evolver.instance_eval(%q{
				alias :original_next_generation! :next_generation!
				alias :original_to_s :to_s

				def next_generation!
					best_individual = population.best

					original_next_generation!

					if population.best < best_individual
						population.remove(population.worst)
						population.add(best_individual)
					end
				end

				def to_s
					"<< weak elitism >> " + original_to_s
				end
			})
		end

		# this function adds strong elistism to a evolver using instance_eval
		#
		# strong elitism: copy best n parents into offspring population (replace worst n childrens)
		# 
		# TODO: add some elegance to this code ;-)

		def Evolvers.add_strong_elistism(evolver, n = 1)
			evolver.population rescue raise "Evolver not supported!"

			if (n == 1)
				evolver.instance_eval("
					alias :original_next_generation! :next_generation!
					alias :original_to_s :to_s

					def next_generation!
						best = population.best

						original_next_generation!

						population.remove(population.worst)
						population.add(best)
					end

					def to_s
						'<< strong elitism >> ' + original_to_s
					end
				")
			else
				evolver.instance_eval("
					alias :original_next_generation! :next_generation!
					alias :original_to_s :to_s

					def next_generation!
						best = population.best(#{n})

						original_next_generation!

						worst = population.worst(#{n})
						worst.each { |individual| population.remove(individual) }
						best.each { |individual| population.add(individual) }
					end

					def to_s
						'<< strong elitism >> ' + original_to_s
					end
				")
			end
		end
	end
end