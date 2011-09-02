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

	# Base-Class for evolvers. Create a subclass and implement the
	# missing functionality to create your own Evolver.

	class Evolver
		include Observable

		# constant to improve readability
		REQUIRED_PARAMETER = nil

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
		#	
		# or:required_parameters?
		#
		#	evolver = EvoSynth::Evolver.new(config) do |evolver|
		#	    evolver.individual = MaxOnes.create_individual
		#	    evolver.evaluator  = MaxOnes::MaxOnesEvaluator.new
		#	end
		#
		# Note:	The block-invocation have a higher priority than initializing
		#				with config. The last example implies that config will be
		#				overwritten.

		def initialize(configuration = nil) #:yields: self
			@generations_computed = 0
			@configuration = nil

			create_accessors_for_parameters(required_parameters?)
			set_default_values!
			use_configuration(configuration) unless configuration.nil?
			if block_given?
				yield self
				generate_configuration!
			end
			valid_configuration?
			setup!
		end

		#Returns a deep copy of this evolver

		def deep_clone
			my_clone = self.clone
			my_clone.instance_variable_set(:@parameters, @parameters.clone)
			properties = @parameters.clone
			properties.each_key { |key| properties[key] = self.send(key) }
			my_clone.use_configuration(EvoSynth::Configuration.new(properties).deep_clone)
			my_clone.instance_variable_set(:@configuration, @configuration.deep_clone)
			my_clone
		end

		# TODO: rdoc

		def reset!(configuration = nil)
			set_default_values!
			use_configuration(configuration.nil? ? @configuration : configuration)
			valid_configuration?
			setup!
		end

		# Called by constructor. Use this function to initialize your Evolver.
		# (instead of overwriting the constructor!)

		def setup!
			raise NotImplementedError
		end

		#	:call-seq:
		#		create_accessors_for_configuration(configuration_hash)
		#
		# initializes the evolver with the needed configuration parameters

		def create_accessors_for_parameters(parameters)
			raise ArgumentError, "argument type not supported" unless parameters.is_a?(Hash)

			@parameters = parameters
			@parameters.each_key { |key| self.class.send(:attr_accessor, key) }
		end

		# TODO: rdoc

		def set_default_values!
			@parameters.each_pair { |key, default| self.send("#{key.id2name}=".to_sym, default) unless default.nil? }
		end

		#	:call-seq:
		#		use_configuration(Configuration)
		#
		# use a given configuration (deep clones the given configuration!!) and check if it is valid

		def use_configuration(configuration) #:yields: self
			set_configuration(configuration)
			if block_given?
				yield self
				generate_configuration!
			end
			valid_configuration?
		end

		#	:call-seq:
		#		valid_configuration? -> True/False
		#
		# check if the current evolver configuration is complete and valid

		def valid_configuration?
			@parameters.each_key do |key|
				raise "evolver configuration is missing '#{key.id2name}' parameter" if self.send(key).nil?
			end
		end

		#	:call-seq:
		#		required_parameters? -> Hash
		#
		# overwrite this, it should return a hash containing the required parameters.
		#
		# key is the accessor-name, value is default or REQUIRED_PARAMETER (nil)
		#
		# example:
		#
		# 	def required_parameters?
		#	{
		#	    :population                 => REQUIRED_PARAMETER,
		#	    :evaluator                  => REQUIRED_PARAMETER,
		#	    :mutation                   => REQUIRED_PARAMETER,
		#	    :parent_selection           => DEFAULT_SELECTION,
		#	    :recombination              => DEFAULT_RECOMBINATION,
		#	    :recombination_probability  => DEFAULT_RECOMBINATION_PROBABILITY,
		#	    :child_factor               => DEFAULT_CHILD_FACTOR
		#	}
		#	end
		#

		def required_parameters?
			raise NotImplementedError
		end

		# this function start the computation of the evolver, the given block is called each generation
		# to check if the next generation should be computed. possible arities of the block are 0,1 and 2.
		# returns result?.
		#
		# example:
		#
		#	Evolver.run_while { am_i_skynet? }                                     # "external" stop criteria
		#	Evolver.run_while { |evolver| evovler.generations_computed <= 42 }     # run 42 generations
		#	
		#	# run 42 generations or stop if a fitness of 0.0 has been reached:
		#	Evolver.run_while { |evovler| evovler.generations_computed <= 42 and evovler.best_solution?.fitness > 0.0 }
		#

		def run_while(&condition) # :yields: evolver, generations_computed
			@generations_computed = 0
			changed
			notify_observers self, @generations_computed

			while yield self
				next_generation!
				@generations_computed += 1
				changed
				notify_observers self, @generations_computed
			end

			result?
		end

		# be compatible to EvoSynth 0.1

		def run_until(&condition) # :yields: evolver
			run_while { |evolver| !yield evolver}
		end

		# wrapper for run_while { |gen| gen == max_generations}

		def run_until_generations_reached(max_generations)
			run_until { |evolver| evolver.generations_computed == max_generations }
		end

		# wrapper for run_while, constructs a Goal class to use the <=> to compare the fitness values

		def run_until_fitness_reached(fitness)
			goal = Goal.new(fitness)
			run_while { |evolver| evolver.best_solution? >= goal }
		end

    #run only for one generation

    def run_next_generation
      if @generations_computed == 0
        changed
        notify_observers self, @generations_computed
      end
      next_generation!
      @generations_computed += 1
      changed
      notify_observers self, @generations_computed
    end

		# implement this to generate the next generation (individuals, whatever) of your evolver

		def next_generation!
			raise NotImplementedError
		end

		# this function should return the best solution

		def best_solution?
			raise NotImplementedError
		end

		# this function should return the worst solution

		def worst_solution?
			raise NotImplementedError
		end

		# this function should return the "result" of the evolver, it will get called at the end of run_while

		def result?
			raise NotImplementedError
		end

		# returns a human-readable representation of the evolver

		def to_s
			"evolver"
		end


		private

		#	:call-seq:
		#		set_configuration(Configuration)
		#
		# set a given configuration (deep clones the given configuration!!)

		def set_configuration(configuration)
			@configuration = configuration.deep_clone
			@parameters.each_pair do |key, default_value|
				value = configuration.send("#{key.id2name}") rescue nil
				self.send("#{key.id2name}=".to_sym, value) unless value.nil?
			end
		end

		#Generate from required parameters and attributes a configuration

		def generate_configuration!
			properties = @parameters.clone
			properties.each_key { |key| properties[key] = self.send(key) }
			@configuration = EvoSynth::Configuration.new(properties).deep_clone
		end
		
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