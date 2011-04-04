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

	context "when initialized with objects which implements deep_clone" do
		setup do
			@configuration = EvoSynth::Configuration.new do |conf|
				conf.individual	= EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(64) { EvoSynth.rand_bool } )
				conf.population	= EvoSynth::Population.new(20) { EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(64) { EvoSynth.rand_bool } ) }
			end
		end

		should "deep_clone returns a deep copy" do
			my_clone = @configuration.deep_clone
			assert_not_equal my_clone.object_id, @configuration.object_id
			assert_not_equal my_clone.properties.object_id, @configuration.properties.object_id
			my_clone.properties.each_key do |key|
				assert_not_equal my_clone.properties[key].object_id, @configuration.properties[key].object_id
			end
			assert_kind_of EvoSynth::Configuration, my_clone
			assert_kind_of EvoSynth::MaximizingIndividual, my_clone.properties[:individual]
			assert_kind_of EvoSynth::Population, my_clone.properties[:population]
			assert_equal my_clone.properties[:individual].fitness, @configuration.properties[:individual].fitness
		end
	end
end

