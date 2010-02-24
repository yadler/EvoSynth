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
	module MetaOperators

		# This operator is a container for other operators. When SequentialCombinedOperator gets called with a method,
		# that it does not implement, each operator has a probability to get called with that method. But in contrast to
		# the ProportionalCombinedOperator all operators will get called.
		# 
		# Most likely you will combine mutations and recombinations and therefore mutate() or recombine() will get called.

		class SequentialCombinedOperator

			def initialize(*ops)
				@operators = []
				ops.each { |operator| self << operator }
			end

			# default probability is 1.0

			def <<(operator)
				@operators << [operator, 1.0]
				self
			end


			def add_with_possibility(operator, probability)
				probability = 1.0 if probability > 1.0
				@operators << [operator, probability]
				self
			end


			def method_missing(method_name, *args)
				raise "no operator to call" if @operators.empty?

				result = args
				@operators.each do |operator|
					result = operator[0].send(method_name, *result) if EvoSynth.rand < operator[1]
				end

				result
			end


			def to_s
				operators_to_s = []
				@operators.each { |op| operators_to_s << "#{op[0].to_s} (probability: #{op[1]})" }
				"combinded operator <operators: #{operators_to_s.join(', ')}>"
			end

		end

	end
end