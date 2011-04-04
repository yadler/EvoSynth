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


class BinaryGenomeTest < Test::Unit::TestCase

	context "when created without intital value" do
		setup do
			@genome = EvoSynth::BinaryGenome.new
		end

		should "#changed be true" do
			assert @genome.changed?
		end

		should "size == 1" do
			assert_equal 1, @genome.size
		end

		should "genome[0] == 0" do
			assert_equal 0, @genome[0]
		end

		should "genome[0] == 1, after flip! 0" do
			@genome.flip!(0)
			assert_equal 1, @genome[0]
		end

		should "deep_clone work as expected" do
			@genome.changed = false
			my_clone = @genome.clone
			assert_equal my_clone.changed?, @genome.changed?
			@genome.flip!(0)
			assert_not_equal my_clone[0], @genome[0]
			assert_not_equal my_clone.changed?, @genome.changed?
			my_clone = @genome.clone
			assert_equal my_clone.changed?, @genome.changed?
			assert_not_equal my_clone.object_id, @genome.object_id
			assert my_clone.kind_of?(EvoSynth::BinaryGenome)
		end
	end

	context "when created with 87" do
		setup do
			@genome = EvoSynth::BinaryGenome.new(87)
		end

		should "#changed be true" do
			assert @genome.changed?
		end

		should "genome have the correct bits" do
			assert_equal 1, @genome[0]
			assert_equal 1, @genome[1]
			assert_equal 1, @genome[2]
			assert_equal 0, @genome[3]
			assert_equal 1, @genome[4]
			assert_equal 0, @genome[5]
			assert_equal 1, @genome[6]
		end

		should "size == 7" do
			assert_equal 7, @genome.size
		end

		should "to_s == '1010111'" do
			assert_equal '1010111', @genome.to_s
		end

		should "@genome[1] == 0" do
			assert_equal 1, @genome[1]
		end

		should "@genome[1,3] == [1,1,0]" do
			assert_equal [1,1,0], @genome[1,3]
		end

		should "@genome[3,4] == [0,1,0,1]" do
			assert_equal [0,1,0,1], @genome[3,4]
		end

		should "@genome[1..3] == [1,1,0]" do
			assert_equal [1,1,0], @genome[1..3]
		end

		should "@genome['foo'] raise a exception" do
			assert_raise(ArgumentError) { @genome['foo'] }
		end

		should "@genome[1,2,3] raise a exception" do
			assert_raise(ArgumentError) { @genome[1,2,3] }
		end

		should "to_s == '1000011', after 2 flips at the correct position" do
			@genome.flip!(2)
			@genome.flip!(4)
			assert_equal '1000011', @genome.to_s
		end

		should "@genome[]= should work" do
			assert_equal 1, @genome[4]
			@genome[4] = 0
			assert_equal 0, @genome[4]
			@genome[4] = 1
			assert_equal 1, @genome[4]
		end

		should "@genome[0..2]= should work" do
			assert_equal [1,1,1], @genome[0..2]
			@genome[0..2] = 0
			assert_equal [0,0,0], @genome[0..2]
			@genome[0..2] = 1
			assert_equal [1,1,1], @genome[0..2]
		end

		should "@genome[0..2]= [..] should work" do
			assert_equal [1,1,1], @genome[0..2]
			@genome[0..2] = [0,1,0]
			assert_equal [0,1,0], @genome[0..2]
			@genome[0..2] = [1,1,1]
			assert_equal [1,1,1], @genome[0..2]
		end

		should "@genome[4..6]= [..] should work" do
			assert_equal [1,0,1], @genome[4..6]
			@genome[4..6] = [0,1,1]
			assert_equal [0,1,1], @genome[4..6]
			@genome[4..6] = [1,0,1]
			assert_equal [1,0,1], @genome[4..6]
		end

		should "@genome[3,3]= should work" do
			assert_equal [0,1,0], @genome[3,3]
			@genome[3,3] = 0
			assert_equal [0,0,0], @genome[3,3]
			@genome[3,3] = 1
			assert_equal [1,1,1], @genome[3,3]
		end

	end
end