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

		# TODO: document me, could be used to swap mutations after N generations

		class ConditionalCombinedOperator

			def initialize
				@operators = []
			end

			#Return a deep copy of the configuration

			def deep_clone
				my_clone = self.clone
				my_clone.instance_variable_set(:@operators, [])
				@operators.each do |operators|
					my_clone.add( operators[0].deep_clone) { operators[1]}
				end
				my_clone
			end

			# condition has to return boolean

			def add(operator, &condition)
				@operators << [operator, condition]
				self
			end

			def method_missing(method_name, *args)
				raise "no operator to call" if @operators.empty?

				result = args
				@operators.each do |operator|
					result = operator[0].send(method_name, *result) if operator[1].call
				end

				result
			end


			def to_s
				operators_to_s = []
				@operators.each { |op| operators_to_s << "#{op[0].to_s} (probability: #{op[1]})" }
				"conditional combinded operator <operators: #{operators_to_s.join(', ')}>"
			end

		end

	end
end