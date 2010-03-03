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

	# Base module for individuals

	module Individual
		include Comparable

		# Genome of the Individual, it should provide a changed attribute

		attr_accessor :genome

		# Returns the fitness of this individual

		attr_reader :fitness

		# Sets the fitness value of this individual, also sets genome.changed to true.

		def fitness=(value)
			@fitness = value
			@genome.changed = false
		end

		# returns true, if this individual (most of the time its genome) has changed. otherwise it
		# will return false.

		def changed?
			@genome.changed?
		end

		# clones a individual and its genome (deep copy)

		def deep_clone
			my_clone = self.clone
			my_clone.genome = Marshal.load( Marshal.dump( self.genome ) )
			my_clone
		end

		# If you compare individuals the semantic of "<=>" is the following:
		#
		#	a > b  -> individual a is a better solution than individual b
		#	a < b  -> individual b is a better solution than individual a
		#	a == b -> a and b have a equal fitness value

		def <=>(another)
			compare_fitness_values(fitness, another.fitness)
		end

		# Should be implemented by Classes that mix-in the Individual module

		def compare_fitness_values(one, two)
			raise NotImplementedError, "please implement compare_fitness_values!"
		end

		# Returns wether this Individual needs to be minimized

		def minimizes?
			compare_fitness_values(1,0) < 0
		end

		# Returns wether this Individual needs to be maximized

		def maximizes?
			compare_fitness_values(1,0) > 0
		end

	end

end