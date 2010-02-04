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
	module Mutations

		class CombinedMutation

			def initialize(*args)
				@mutations = []
				args.each { |mutation| self << mutation }
			end

			def <<(mutation)
				@mutations << [mutation, 1.0 / (@mutations.size > 0 ? @mutations.size : 1.0)]
				normalize_possibilities
			end

			def add_with_possibility(mutation, possibility)
				@mutations << [mutation, possibility]
				normalize_possibilities
			end

			def mutate(individual)
				mutated = individual

				unless @mutations.empty?
					mutation = nil
					rand_value = rand

					sum = 0.0
					@mutations.each do |m|
						sum += m[1];
						mutation = m[0];
						break if sum >= rand_value
					end

					mutated = mutation.mutate(individual)
				end

				mutated
			end

			def to_s
				mutations_to_s = []
				@mutations.each { |mut| mutations_to_s << "#{mut[0].to_s} (probability: #{mut[1]})" }
				"combinded mutation <mutations: #{mutations_to_s.join(', ')}>"
			end

			private

			def normalize_possibilities
				sum = @mutations.inject(0.0) { |sum, mutation| sum += mutation[1] }

				if sum > 1.0
					subtract = (sum - 1.0) / (@mutations.size)
					@mutations.each { |mutation| mutation[1] -= subtract }
				end
			end
		end

	end
end