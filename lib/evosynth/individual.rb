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

	class ArrayGenome < Array

		attr_accessor :changed

		def initialize(*args)
			super
			@changed = true
		end


		def [](*n)
			@changed = true
			super(*n)
		end

		def to_s
			self * ", "
		end
	end


	module Individual

		attr_accessor :genome

		def to_s
			"fitness = #{fitness}, genome = [#{genome}]"
		end

		def fitness
			if genome.changed
				@fitness = calculate_fitness
				@genome.changed = false
			end

			@fitness
		end

		def deep_clone
			my_clone = self.clone
			my_clone.genome = self.genome.clone
			my_clone
		end
	end


	# The following two mixins decide wether you have a
	# minimization or maximization Problem
	#
	# In either case if you compare individuals with a > b,
	#	individual a is a better solution than individual b


	# Mixin for Individuals (for minimizing Problems)

	module MinimizingIndividual
		include Individual
		include Comparable

		def <=>(anOther)
			cmp = fitness <=> anOther.fitness
			-1 * cmp
		end

	end

	# Mixin for Individuals (for maximizing Problems)

	module MaximizingIndividual
		include Individual
		include Comparable

		def <=>(anOther)
			fitness <=> anOther.fitness
		end

	end

end