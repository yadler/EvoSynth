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


require 'observer'


module EvoSynth
	module Algorithms

		module RunnableAlgorithm

			attr_reader :generations_computed

			def run_until(&condition) # :yields: generations computed, best solution
				@generations_computed = 0
				changed
				notify_observers @generations_computed, self

				case condition.arity
					when 1
						loop_condition = lambda { !yield @generations_computed }
					when 2
						loop_condition = lambda { !yield @generations_computed, best_solution }
				else
					loop_condition = nil
				end

				while loop_condition.call
					next_generation
					@generations_computed += 1
					changed
					notify_observers @generations_computed, self
				end

				return_result
			end

			def run_until_generations_reached(max_generations)
				run_until { |gen| gen == max_generations }
			end

			def run_until_fitness_reached(fitness)
				goal = Goal.new(fitness)
				run_until { |gen, best| best > goal }
			end

			private

			class Goal
				def initialize(goal)
					@goal = goal
				end

				def fitness
					@goal
				end
			end

		end

		module Algorithm
			include Observable
			include RunnableAlgorithm

			def init_profile(*properties)
				@properties = properties
				@properties.each do |property|
					if property.is_a?(Symbol)
						self.class.send(:attr_accessor, property)
					elsif property.is_a?(Hash)
						property.keys.each { |key| self.class.send(:attr_accessor, key) }
					else
						raise ArgumentError, "argument type not supported"
					end
				end
			end			

			def use_profile(profile)
				@properties.each do |property|
					if property.is_a? Symbol
							use_property(profile, property)
					elsif property.is_a? Hash
							use_property_hash(profile, property)
					end
				end
			end

			private

			def use_property(profile, property)
				accessor_symbol = "#{property.id2name}=".to_sym
				value = profile.send(property.to_sym) rescue value = nil
				raise "algorithm profile is missing '#{property.id2name}' field" if value.nil?
				self.send(accessor_symbol, value)
			end

			def use_property_hash(profile, property_hash)
				property_hash.each_pair do |key, default_value|
					accessor_symbol = "#{key.id2name}=".to_sym
					value = profile.send(key.to_sym) rescue value = nil
					value = default_value if value.nil?
					self.send(accessor_symbol, value)
				end
			end

		end


	end
end