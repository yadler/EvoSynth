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

		# Array based genome, which keeps track of changes (changed attribute)
		# to reduce the need to recalculate the fitness function in the
		# Individual module

		class ArrayGenome < Array

			# true if the genome has changed - has to be set to false manually
			attr_accessor :changed

			# Create a printable version of the genome
			def to_s
				self * ", "
			end

		end

		# see http://ruby-doc.org/doxygen/1.8.4/group__ruby__ary.html#ga9
		# see rb_ary_store and rb_ary_modify

		METHODS_THAT_CHANGE_ARRAY = ['initialize', '[]=', 'delete', 'delete_at', 'collect!', 'map!', '<<', 'reject!', 'uniq!', 'unshift',
		                             'shift', 'sort!', 'pop', 'push', 'flatten!', 'reverse!', 'slice!', 'clear']

		METHODS_THAT_CHANGE_ARRAY.each do |method_name|
			ArrayGenome.class_eval("def #{method_name}(*args)
									  @changed = true
									  super
								    end")
		end

	end
end