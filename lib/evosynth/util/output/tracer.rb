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
	module Util

#		NODE_STRING = "\\node[box] (one) [below=0.6cm of #{$parent.delete(".:")}] {Software Schicht 1};"

		def Util.tracer(&block)
			$parent = "start"
			$parents = [] << $parent
			$lines = []

			set_trace_func lambda { |event, file, line, id, binding, classname|
				next if classname.to_s =~ /Genome/

				if (event == "call" || event == "return") && classname.inspect =~ /EvoSynth/
#					puts "#{classname}.#{id}"
					if event == "return"
						$parent = $parents.pop
						name = classname.to_s.gsub(/.*(::)/, "")
#						$parent = $parents.pop if name == $parent
						$lines << "#{name} --> #{$parent}:#{id}"
						$lines << "deactivate #{name}"
#						$lines << "REMOVED: #{$parent} \t\t PARENTS = #{$parents.to_s}"
					elsif event == "call"
						name = classname.to_s.gsub(/.*(::)/, "")
						$lines << "#{$parent} -> #{name}:#{id}"
						$lines << "activate #{name}"

						$parents << name if name != $parents.last
#						$lines << "ADDED  : #{name} \t\t PARENTS = #{$parents.to_s}"
						$parent = name
					end
				end
			}

			block.call

			set_trace_func nil
		end

	end
end