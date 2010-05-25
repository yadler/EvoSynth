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


require 'shoulda'

require 'evosynth'


class ConfigurationTest < Test::Unit::TestCase

	context "when initialized with a symbol" do

		should "work as expected with simple stuff" do
			configuration = EvoSynth::Configuration.new
			assert_raise(ArgumentError) { (configuration.foo) }
			assert_raise(ArgumentError) { (configuration.bar) }
			configuration.foo= "foo"
			configuration.bar= "bar"
			assert_equal("foo", configuration.foo)
			assert_equal("bar", configuration.bar)
		end

		should "work as expected with more complex stuff" do
			configuration = EvoSynth::Configuration.new
			assert_raise(ArgumentError) { (configuration.foo) }
			assert_raise(ArgumentError) { (configuration.bar) }
			configuration.foo= [1,2,3,4,5]
			struct = Struct.new(:foo,:bar,:baz)
			configuration.bar= struct
			assert_equal([1,2,3,4,5], configuration.foo)
			assert_equal(struct, configuration.bar)
		end

		should "work with defaults" do
			configuration = EvoSynth::Configuration.new(:foo, :bar => "bar", :baz => "baz")
			assert_nil(configuration.foo)
			assert_equal("bar", configuration.bar)
			assert_equal("baz", configuration.baz)
		end

		should "be able to delete keys" do
			configuration = EvoSynth::Configuration.new(:foo, :bar => "bar", :baz => "baz")
			assert_nil(configuration.foo)
			assert_equal("bar", configuration.bar)
			assert_equal("baz", configuration.baz)
			configuration.delete(:foo)
			assert_raise(ArgumentError) { (configuration.foo) }
			configuration.delete(:bar)
			assert_raise(ArgumentError) { (configuration.bar) }
		end

	end

end