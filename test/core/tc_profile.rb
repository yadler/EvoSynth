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


class ProfileTest < Test::Unit::TestCase

	context "when initialized with a symbol" do

		should "work as expected with simple stuff" do
			profile = EvoSynth::Core::Profile.new
			assert_raise(ArgumentError) { (profile.foo) }
			assert_raise(ArgumentError) { (profile.bar) }
			profile.foo= "foo"
			profile.bar= "bar"
			assert_equal("foo", profile.foo)
			assert_equal("bar", profile.bar)
		end

		should "work as expected with more complex stuff" do
			profile = EvoSynth::Core::Profile.new
			assert_raise(ArgumentError) { (profile.foo) }
			assert_raise(ArgumentError) { (profile.bar) }
			profile.foo= [1,2,3,4,5]
			struct = Struct.new(:foo,:bar,:baz)
			profile.bar= struct
			assert_equal([1,2,3,4,5], profile.foo)
			assert_equal(struct, profile.bar)
		end

		should "work with defaults" do
			profile = EvoSynth::Core::Profile.new(:foo, :bar => "bar", :baz => "baz")
			assert_nil(profile.foo)
			assert_equal("bar", profile.bar)
			assert_equal("baz", profile.baz)
		end

	end

end