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
	module Core

		# This class is used to create and maintain a population

		class Population <  EvoSynth::Core::ArrayGenome

			# Setup a population of individuals with the given size
			# and a block to initialize each individual

			def initialize(*args)
				super(*args)
				self.map! { |individual| yield } if block_given?
			end


			def deep_clone
				my_clone = self.clone
				self.each_index { |index| my_clone[index] = self[index].deep_clone }
				my_clone
			end


			def add(individual)
				self << individual
			end


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


			def best(count = 1)
				self.sort! if self.changed?
				self.changed = false
				count == 1 ? self.last : self.last(count).reverse
			end


			def worst(count = 1)
				self.sort! if self.changed?
				self.changed = false
				count == 1 ? self.first : self.first(count).reverse
			end


			def to_s
				"Population (size=#{self.size}, best.fitness=#{best.fitness}, worst.fitness=#{worst.fitness})"
			end

		end

	end
end
