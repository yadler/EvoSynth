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

		# see Weicker, page 62 - used to calculated diversity of binary genomes!
		# use only with binary genomes (1/0 or true/false)W

		def EvoBench.diversity_entropy(population)
			length = population.first.genome.size
			ones_cnt, zero_cnt = [0] * length, [0] * length

			population.each do |individual|
				individual.genome.each_with_index do |gene, index|
					gene == true || gene == 1 ? ones_cnt[index] += 1 : zero_cnt[index] += 1
				end
			end

			# TODO: is this a mistake in the book? it tries to calculate log(0)! (all ones or zeros)

			ones_cnt.map! { |one| val = one / population.size.to_f; val == 0 ? 1 : val }
			zero_cnt.map! { |zero| val = zero / population.size.to_f; val == 0 ? 1 : val }

			sum = 0.0
			length.times { |i| sum += -zero_cnt[i] * Math.log(zero_cnt[i]) - ones_cnt[i] * Math.log(ones_cnt[i]) }

			(1.0 / length) * sum
		end

	end
end