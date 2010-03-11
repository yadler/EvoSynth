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

	# This class is used to create and maintain a population. In this case a population
	# is simply a Array of individuals that keeps track of changes.

	class Population <  EvoSynth::ArrayGenome

		#	:call-seq:
		#		Population.new -> Population
		#		Population.new(size) -> Population (with given size)
		#		Population.new(size) { block } -> Population (with given size and block to intialize each individual)
		#
		# Creates a population

		def initialize(*args)
			super(*args)
			self.map! { |individual| yield } if block_given?
		end

		# Returns a clone of the population (deep_clone)

		def deep_clone
			my_clone = self.clone
			self.each_index { |index| my_clone[index] = self[index].deep_clone }
			my_clone
		end

		# Adds a individual to the population.

		def add(individual)
			self << individual
		end

		# Removes a give individual (first occurence) from the population.

		def remove(individual)
			# FIXME: this is a rather ugly hack
			# -> should be replaced with a cool 1.9 function

			found = nil
			self.each_index do |index|
				if self[index] == individual
					found = index
					break
				end
			end

			self.delete_at(found) if found != nil
		end


		#	:call-seq:
		#		p = Population.new
		#		p.best					#=> Returns the best individual
		#		p.best(3)				#=> Returns the 3 best individuals
		#
		# Returns the best N individuals (by comparing with <=>) of the population.

		def best(count = 1)
			self.sort! if self.changed?
			self.changed = false
			count == 1 ? self.last : self.last(count).reverse
		end

		#	:call-seq:
		#		p = Population.new
		#		p.worst					#=> Returns the worst individual
		#		p.worst(3)				#=> Returns the 3 worst individuals
		#
		# Returns the worst N individuals (by comparing with <=>) of the population.

		def worst(count = 1)
			self.sort! if self.changed?
			self.changed = false
			count == 1 ? self.first : self.first(count).reverse
		end

		#	:call-seq:
		#		to_s -> string
		#
		# Returns description of this individual
		#
		#		p = Population.new
		#		p.to_s					#=> "Population <size=0>"

		def to_s
			begin
				"Population <size=#{self.size}, best.fitness=#{best.fitness}, worst.fitness=#{worst.fitness}>"
			rescue
				"Population <size=#{self.size}>"
			end
		end

	end

end
