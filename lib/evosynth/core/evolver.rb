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

	# Base-Class for evolvers. Create a subclass and implement the
	# missing functionality to create your own Evolver.

	class Evolver
		include Observable

		# constant to improve readability
		REQUIRED_FIELD = nil

		# returns the number of generations that has been computed by the evolver
		attr_reader :generations_computed

		# returns the Configuration of the evolver
		attr_reader :configuration


		# Creates a new Evolver using the given Configuration.
		#
		# <b>DO NOT OVERWRITE THIS</b>, except you what you do!
		#
		# usage:
		#
		#    evolver = EvoSynth::Evolver.new(config)
		#
		# or:
		#
		#	evolver = EvoSynth::Evolver.new do |evolver|
		#	    evolver.individual = MaxOnes.create_individual
		#	    evolver.evaluator  = MaxOnes::MaxOnesEvaluator.new
		#	end

		def initialize(configuration = nil) #:yields: self
			create_accessors_for_configuration(required_configuration?)
			use_configuration(configuration) unless configuration.nil?
			yield self if block_given?
			valid_configuration?
			setup
		end

		# Called by constructor. Use this function to initialize your Evolver.
		# (instead of overwriting the constructor!)

		def setup
			raise NotImplementedError
		end

		#	:call-seq:
		#		create_accessors_for_configuration(configuration_hash)
		#
		# initializes the evolver with the needed configuration-fields

		def create_accessors_for_configuration(property_hash)
			raise ArgumentError, "argument type not supported" unless property_hash.is_a?(Hash)

			@property_hash = property_hash
			@property_hash.each_pair do |key, default_value|
				self.class.send(:attr_accessor, key)
				self.send("#{key.id2name}=".to_sym, default_value) unless default_value.nil?
			end
		end

		#	:call-seq:
		#		use_configuration(Configuration)
		#
		# use a given configuration

		def use_configuration(configuration)
			@configuration = configuration
			@property_hash.each_pair do |key, default_value|
				value = configuration.send("#{key.id2name}") rescue nil
				self.send("#{key.id2name}=".to_sym, value) unless value.nil?
			end
		end

		#	:call-seq:
		#		valid_configuration? -> True/False
		#
		# check if the current evolver configuration is complete and valid

		def valid_configuration?
			@property_hash.each_key do |key|
				raise "evolver configuration is missing '#{key.id2name}' field" if self.send(key).nil?
			end
		end

		#	:call-seq:
		#		required_configuration? -> Hash
		#
		# overwrite this, it should return a hash containing the required fields.
		#
		# key is the accessor-name, value is default or REQUIRED_FIELD (nil)
		#
		# example:
		#
		# 	def required_configuration?
		#	{
		#	    :population                 => REQUIRED_FIELD,
		#	    :evaluator                  => REQUIRED_FIELD,
		#	    :mutation                   => REQUIRED_FIELD,
		#	    :parent_selection           => DEFAULT_SELECTION,
		#	    :recombination              => DEFAULT_RECOMBINATION,
		#	    :recombination_probability  => DEFAULT_RECOMBINATION_PROBABILITY,
		#	    :child_factor               => DEFAULT_CHILD_FACTOR
		#	}
		#	end
		#

		def required_configuration?
			raise NotImplementedError
		end

		# this function start the computation of the evolver, the given block is called each generation
		# to check if the next generation should be computed. possible arities of the block are 0,1 and 2.
		# returns return_result.
		#
		# example:
		#
		#	Evolver.run_until { am_i_already_skynet? }                             # "external" stop criteria
		#	Evolver.run_until { |gen| gen <= 42 }                                  # run 42 generations
		#	Evolver.run_until { |gen, best| gen <= 42 or best.fitness == 0.0 }     # run 42 generations or stop if a fitness of 0.0 has been reached
		#

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

		# wrapper for run_until { |gen| gen == max_generations}

		def run_until_generations_reached(max_generations)
			run_until { |gen| gen == max_generations }
		end

		# wrapper for run_until, constructs a Goal class to use the <=> to compare the fitness values

		def run_until_fitness_reached(fitness)
			goal = Goal.new(fitness)
			run_until { |gen, best| best >= goal }
		end

		# implement this to generate the next generation (individuals, whatever) of your evolver

		def next_generation
			raise NotImplementedError
		end

		# this function should return the best solution

		def best_solution
			raise NotImplementedError
		end

		# this function should return the worst solution

		def worst_solution
			raise NotImplementedError
		end

		# this function should return the "result" of the evolver, it will get called at the end of run_until

		def return_result
			raise NotImplementedError
		end

		# returns a human-readable representation of the evolver

		def to_s
			"evolver"
		end


		private


		# simple class to compare a given fitness-goal with a individual using the <=>,
		# this is done to respect minimizing and maximizin evolvers.

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