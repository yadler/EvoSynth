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

require 'evosynth'

describe EvoSynth::Util::MDArray do

	describe "when first created" do
		before(:each) do
			@mda = EvoSynth::Util::MDArray.new(1, 2)
		end

		it "every element should be nil" do
			@mda.each_index { |row, col| @mda[row, col].should be_nil }
		end

#		removed because of performance issues
#
#		it "should respect its lower bound" do
#			lambda { @mda[2,1] }.should raise_error(IndexError)
#		end
#
#		it "should respect its upper bound" do
#			lambda { @mda[0,2] }.should raise_error(IndexError)
#		end

	end

	describe "when created with default value (0)" do
		before(:each) do
			@mda = EvoSynth::Util::MDArray.new(1, 3, 0)
		end

		it "every element should be 0" do
			@mda.each_index { |row, col| @mda[row, col].should == 0 }
		end

		it "after assignment of 1 to a element, it should be one" do
			@mda[0,0].should == 0
			@mda[0,0] = 1
			@mda[0,0].should == 1
		end
	end
end