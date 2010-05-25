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
	module Evolvers

		# This module provides the ability to use the Configuration class in a evolver.

		module ConfigurationUsingEvolver

			def init_configuration(*properties)
				@properties = properties
				@properties.each do |property|
					if property.is_a?(Symbol)
						self.class.send(:attr_accessor, property)
					elsif property.is_a?(Hash)
						property.keys.each { |key| self.class.send(:attr_accessor, key) }
					else
						raise ArgumentError, "argument type not supported"
					end
				end
			end

			def use_configuration(configuration)
				@configuration = configuration
				@properties.each do |property|
					if property.is_a? Symbol
							use_property(configuration, property)
					elsif property.is_a? Hash
							use_property_hash(configuration, property)
					end
				end
			end

			private

			def use_property(configuration, property)
				accessor_symbol = "#{property.id2name}=".to_sym
				value = configuration.send(property.to_sym) rescue value = nil
				raise "evolver configuration is missing '#{property.id2name}' field" if value.nil?
				self.send(accessor_symbol, value)
			end

			def use_property_hash(configuration, property_hash)
				property_hash.each_pair do |key, default_value|
					accessor_symbol = "#{key.id2name}=".to_sym
					value = configuration.send(key.to_sym) rescue value = nil
					value = default_value if value.nil?
					self.send(accessor_symbol, value)
				end
			end

		end

	end
end