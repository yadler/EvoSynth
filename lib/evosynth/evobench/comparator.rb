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
	module EvoBench

		# TODO: rdoc

		class Comparator

			def Comparator.compare_with_error_probability(results_one, results_two, column)
				puts "comparison (column = '#{column}'):\n\n"

				raise "repetitions are not equal!" if results_one.repetitions != results_two.repetitions

				results_one.dataset.each_index do |index|
					column_one = results_one.dataset[index, column]
					column_two = results_two.dataset[index, column]
					t_value = EvoSynth::EvoBench.t_test(column_one, column_two)
					error_prob = EvoSynth::EvoBench.t_probability(t_value, results_one.repetitions)

					puts "#{index}\tbest (one) = #{EvoSynth::EvoBench.mean(column_one)}\tbest (two) = #{EvoSynth::EvoBench.mean(column_two)}\tt-value=#{t_value}\terror prob.=#{error_prob}"
				end
			end

		end

	end
end