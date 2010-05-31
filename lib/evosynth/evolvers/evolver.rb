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

		# This Class provides some basic functionality for evolvers.

		class Evolver
			include Observable

			attr_reader :generations_computed, :configuration

			def initialize(configuration = nil)
				init_configuration(required_configuration?)
				use_configuration(configuration) unless configuration.nil?
				yield self if block_given?
				check_configuration
				setup
			end

			def setup
				raise NotImplementedError
			end

			def init_configuration(property_hash)
				raise ArgumentError, "argument type not supported" unless property_hash.is_a?(Hash)
				@property_hash = property_hash
				@property_hash.each_pair do |key, default_value|
					self.class.send(:attr_accessor, key)
					self.send("#{key.id2name}=".to_sym, default_value) unless default_value.nil?
				end
			end

			def use_configuration(configuration)
				@configuration = configuration
				@property_hash.each_pair do |key, default_value|
					value = configuration.send("#{key.id2name}") rescue nil
					self.send("#{key.id2name}=".to_sym, value) unless value.nil?
				end
			end

			def check_configuration
				@property_hash.each_key do |key|
					raise "evolver configuration is missing '#{key.id2name}' field" if self.send(key).nil?
				end
			end

			def required_configuration?
				raise NotImplementedError
			end

			def run_until(&condition) # :yields: generations computed, best solution
				@generations_computed = 0
				changed
				notify_observers self, @generations_computed

				case condition.arity
					when 0
						loop_condition = condition
					when 1
						loop_condition = lambda { !yield @generations_computed }
					when 2
						loop_condition = lambda { !yield @generations_computed, best_solution }
				else
					raise ArgumentError, "please provide a block with the arity of 0, 1 or 2"
				end

				while loop_condition.call
					next_generation
					@generations_computed += 1
					changed
					notify_observers self, @generations_computed
				end

				return_result
			end

			def run_until_generations_reached(max_generations)
				run_until { |gen| gen == max_generations }
			end

			def run_until_fitness_reached(fitness)
				goal = Goal.new(fitness)
				run_until { |gen, best| best >= goal }
			end

			def next_generation
				raise NotImplementedError
			end

			def best_solution
				raise NotImplementedError
			end

			def worst_solution
				raise NotImplementedError
			end

			def return_result
				raise NotImplementedError
			end

			def to_s
				"evolver"
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

	end
end