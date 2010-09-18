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
#require 'gnuplot'
require './test/test_util/test_helper'

require 'evosynth'


class RunResultsTest < Test::Unit::TestCase

	context "two Dataset's" do

		setup do

			@conf = EvoSynth::Configuration.new do |cfg|
				cfg.mutation = TestMutationA.new
				cfg.evaluator = TestEvaluator.new
				cfg.individual =  TestMinimizingIndividual.new
			end
			@evolver = EvoSynth::Evolvers::Hillclimber.new(@conf)

			@ds1 = EvoSynth::Logging::DataSet.new(["test1", "test2"])
			@ds1[0] = [1, 2]
			@ds1[1] = [2, 4]
			@ds1[2] = [3, 6]
			@ds1[3] = [4, 8]

			@ds2 = EvoSynth::Logging::DataSet.new(["test1", "test2"])
			@ds2[0] = [10, 20]
			@ds2[1] = [20, 40]
			@ds2[2] = [30, 60]
			@ds2[3] = [40, 80]

			@ds3 = EvoSynth::Logging::DataSet.new(["test1", "test2"])
			@ds3[4] = [33, 33]
			@ds3[2] = [33, 33]
			@ds3[6] = [33, 33]
			@ds3[7] = [33, 33]

			@rs1 = EvoSynth::EvoBench::RunResult.new(@ds1, @evolver, @conf)
			@rs1.elapsed_time = 10
			@rs2 = EvoSynth::EvoBench::RunResult.new(@ds2, @evolver, @conf)
			@rs2.elapsed_time = 5
			@rs3 = EvoSynth::EvoBench::RunResult.new(@ds3, @evolver, @conf)
			@rs3.elapsed_time = 15
		end

		should "have a working union implementation for 2 RunResults" do
			union = EvoSynth::EvoBench::RunResult.union(@rs1, @rs2)

			assert_equal(7.5, union.elapsed_time)
			assert_equal([[1,10],[2,20]], union.dataset[0])
			assert_equal([[2,20],[4,40]], union.dataset[1])
			assert_equal([[3,30],[6,60]], union.dataset[2])
			assert_equal([[4,40],[8,80]], union.dataset[3])
		end

		should "have a working union implementation for 3 datasets" do
			union = EvoSynth::EvoBench::RunResult.union(@rs1, @rs2, @rs3)

			assert_equal(10.0, union.elapsed_time)
			assert_equal([[1,10],[2,20]], union.dataset[0])
			assert_equal([[2,20],[4,40]], union.dataset[1])
			assert_equal([[3,30,33],[6,60,33]], union.dataset[2])
			assert_equal([[4,40],[8,80]], union.dataset[3])
			assert_equal([[33],[33]], union.dataset[4])
			assert_equal([[33],[33]], union.dataset[6])
			assert_equal([[33],[33]], union.dataset[7])
		end

	end
end