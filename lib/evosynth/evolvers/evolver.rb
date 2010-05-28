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


require 'evosynth/evolvers/runnable_evolver'
require 'evosynth/evolvers/configuration_using_evolver'


module EvoSynth
	module Evolvers

		# This Class provides some basic functionality for evolvers, its simply a union
		# of RunnableEvolver and ConfigurationUsingEvolver. Every evolver should mix-in this
		# module of provide similiar functionality to be compatible with the other classes
		# and modules in EvoSynth.

		class Evolver
			include RunnableEvolver
			include ConfigurationUsingEvolver

			def initialize(configuration = nil)
				init_configuration(required_configuration?)
				use_configuration(configuration) unless configuration.nil?
				yield self if block_given?
				check_configuration
				setup
			end

			def required_configuration?
				raise NotImplementedError
			end

			def setup
				raise NotImplementedError
			end

			def next_generation
				raise NotImplementedError
			end

			def best_solution
				raise NotImplementedError
			end

			def worst_solution
				raise NotImplementedError
			end

			def return_result
				raise NotImplementedError
			end

			def to_s
				"evolver"
			end
		end

	end
end