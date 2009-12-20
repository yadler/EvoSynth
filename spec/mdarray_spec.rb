#    Copyright (C) 2009 Yves Adler <yves.adler@googlemail.com>
#
#    This file is part of EvoSynth, a framework for rapid prototyping of
#    evolutionary and genetic algorithms.
#
#    EvoSynth is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Lesser General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    EvoSynth is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public License
#    along with EvoSynth.  If not, see <http://www.gnu.org/licenses/>.

# Author::    Yves Adler (mailto:yves.adler@googlemail.com)
# Copyright:: Copyright (C) 2009 Yves Adler
# License::   LGPLv3

require 'evosynth'

describe EvoSynth::Util::MDArray do

	describe "when first created" do
		before(:each) do
			@mda = EvoSynth::Util::MDArray.new(1, 2)
		end

		it "every element should be nil" do
			@mda.each_index { |row, col| @mda[row, col].should be_nil }
		end

		it "should respect its lower bound" do
			lambda { @mda[2,1] }.should raise_error(IndexError)
		end

		it "should respect its upper bound" do
			lambda { @mda[0,2] }.should raise_error(IndexError)
		end
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