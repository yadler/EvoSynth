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

		# Some useful acceptance conditions

		class LocalSearch

			# AKZEPTANZ-HC (Weicker Page 156)

			class HillclimberAcceptance
				def accepts(parent, child, generation)
					child > parent
				end
			end

			# AKZEPTANZ-SA (Weicker Page 156)
			#
			# FIXME: can't maximize

			class SimulatedAnnealingAcceptance
				attr_accessor :temperature, :alpha

				DEFAULT_START_TEMP = Float::MAX
				DEFAULT_ALPHA = 0.9

				def initialize(start_temp = DEFAULT_START_TEMP, alpha = DEFAULT_ALPHA)
					@temperature = start_temp
					@alpha = alpha
				end

				def accepts(parent, child, generation)
					accepted = false

					if child > parent
						accepted = true
					else
						accepted = true if rand <= Math.exp( -1 * Math.sqrt( (child.fitness - parent.fitness)**2 ) / @temperature)
					end

					@temperature *= @alpha
					accepted
				end
			end

			# AKZEPTANZ-TA (Weicker Page 157)
			#
			# FIXME: can't maximize

			class ThresholdAcceptance
				attr_accessor :temperature, :alpha

				DEFAULT_START_TEMP = Float::MAX
				DEFAULT_ALPHA = 0.9

				def initialize(start_temp = DEFAULT_START_TEMP, alpha = DEFAULT_ALPHA)
					@temperature = start_temp
					@alpha = alpha
				end

				def accepts(parent, child, generation)
					if child > parent || Math.sqrt( (child.fitness - parent.fitness)**2 ) < @temperature
						accepted = true 
					else
						accepted = false
					end
						
					@temperature *= @alpha
					accepted
				end
			end

			# AKZEPTANZ-GD (Weicker Page 158)
			#
			# FIXME: can't minimize

			class GreatDelugeAcceptance
				attr_accessor :temperature, :alpha

				DEFAULT_WATER_LEVEL = Float::MIN
				DEFAULT_RAIN_SPEED = 10.0

				def initialize(start_water_level = DEFAULT_WATER_LEVEL, rain_speed = DEFAULT_RAIN_SPEED)
					@water = start_water_level
					@rain_speed = rain_speed
				end

				def accepts(parent, child, generation)
					if child.fitness > @water + generation * @rain_speed
						true
					else
						false
					end
				end
			end

		end

		# LOKALE-SUCHE (Weicker Page 155)

		class LocalSearch
			include EvoSynth::Algorithms::Algorithm

			DEFAULT_ACCEPTANCE = HillclimberAcceptance.new

			def initialize(profile)
				init_profile :individual, :mutation, :fitness_calculator, :acceptance => DEFAULT_ACCEPTANCE

				use_profile profile

				@fitness_calculator.calculate_and_set_fitness(@individual)
			end

			def to_s
				"local search <mutation: #{@mutation}, individual: #{@individual}>"
			end

			def best_solution
				@individual
			end

			def worst_solution
				@individual
			end

			def return_result
				@individual
			end

			def next_generation
				child = @mutation.mutate(@individual)
				@fitness_calculator.calculate_and_set_fitness(child)
				@individual = child if @acceptance.accepts(@individual, child, @generations_computed)
			end
		end

	end
end
