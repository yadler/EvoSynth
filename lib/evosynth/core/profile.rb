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

		# This class is used to create and maintain a algorithm profile. (uses metaprogramming)
		# TODO: add proper rdoc
		#
		# usage:
		#
		#		profile = EvoSynth::Profile.new(
		#			:individual			=> MaxOnes.create_individual,
		#			:population			=> EvoSynth::Population.new(POP_SIZE) { MaxOnes.create_individual },
		#			:evaluator			=> MaxOnes::MaxOnesEvaluator.new,
		#			:mutation			=> EvoSynth::Mutations::BinaryMutation.new(EvoSynth::Mutations::Functions::FLIP_BOOLEAN)
		#		)

		class Profile

			def initialize(*properties)
				@properties = {}

				properties.each do |property|
					if property.is_a?(Symbol)
						add_symbol(property, nil)
					elsif property.is_a?(Hash)
						add_hash(property)
					else
						raise ArgumentError, "argument type not supported"
					end
				end
			end

			def method_missing(method_name, *args)
				if method_name[-1] == "="
					args = args[0] if args.size == 1
					add_symbol(method_name[0..method_name.size-2].to_sym, args)
				else
					super(*args) unless @properties.has_key?(method_name)
					@properties[method_name]
				end
			end

			def to_s
				"algorithm profile <#{@properties.to_s}>"
			end

			private

			def add_symbol(symbol, value)
				@properties[symbol] = value
			end

			def add_hash(hash)
				hash.each_pair { |key, default_value| @properties[key] = default_value }
			end

		end

	end
end
