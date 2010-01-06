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

	# This class is used to create and maintain a population

	class Population
		include Comparable
		include Enumerable

		attr_accessor :individuals

		# Setup a population of individuals with the given size
		# and a block to initialize each individual

		def initialize(size = 0)
			@individuals = Genome.new(size)
			@individuals.map! { |individual| yield } if block_given?
		end

		def deep_clone
			my_clone = self.clone
			my_clone.individuals = self.individuals.clone
			self.individuals.each_index { |index| my_clone.individuals[index] = self.individuals[index].deep_clone }
			my_clone
		end

		def <=>(anOther)
			@individuals <=> anOther.individuals
		end


		def each
			@individuals.each { |individual| yield individual }
		end


		def map!
			@individuals.map! { |individual| yield individual }
		end


		def add(individual)
			@individuals << individual
		end


		def remove(individual)
			# FIXME: this is a rather ugly hack
			# -> should be replaced with a cool 1.9 function

			found = nil
			@individuals.each_index do |index|
				if @individuals[index] == individual
					found = index
					break
				end
			end

			@individuals.delete_at(found) if found != nil
		end


		def clear_all
			@individuals.clear
		end


		def best(count = 1)
			@individuals.sort!
			count == 1 ? @individuals.last : @individuals.last(count).reverse
		end


		def worst(count = 1)
			@individuals.sort!
			count == 1 ? @individuals.first : @individuals.first(count).reverse
		end


		def [](index)
			@individuals[index]
		end


		def []=(index, individual)
			@individuals[index] = individual
		end


		def empty?
			@individuals.empty?
		end


		def size
			@individuals.size
		end


		def to_s
			"Population (size=#{@individuals.size}, individuals=#{@individuals})"
		end

	end

end
