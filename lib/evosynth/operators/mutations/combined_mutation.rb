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

		# This mutations is a container for other mutations. Each mutation has a probability to get called when
		# CombinedMutation.mutate gets called.

		class CombinedMutation

			#	:call-seq:
			#		CombinedMutation.new -> CombinedMutation
			#		CombinedMutation.new(array_of_mutations) -> CombinedMutation
			#
			# Returns a new CombinedMutation. In the first form, it contains no mutations. In the second it adds all
			# mutations in a given array of mutations to itself, using the << funtion.
			#
			#     combinded_mutation = EvoSynth::Mutations::CombinedMutation.new
			#     combinded_mutation << EvoSynth::Mutations::Identity.new
			#     combinded_mutation << EvoSynth::Mutations::MixingMutation.new
			#
			#     CombinedMutation.new([EvoSynth::Mutations::Identity.new, EvoSynth::Mutations::MixingMutation.new])

			def initialize(*args)
				@mutations = []
				args.each { |mutation| self << mutation }
			end

			#	:call-seq:
			#		CombinedMutation << a_mutation -> CombinedMutation
			#
			#	Adds a mutation to this CombinedMutation, the probabilities will be normalized. Returns CombinedMutation itself.

			def <<(mutation)
				@mutations << [mutation, 1.0 / (@mutations.size > 0 ? @mutations.size : 1.0)]
				normalize_probabilities
				self
			end

			#	:call-seq:
			#		add_with_possibility(mutation, possibility) -> CombinedMutation
			#
			#	Adds a mutation with a given probability to this CombinedMutation. The probabilities will be normalized.
			#	Returns CombinedMutation itself.

			def add_with_possibility(mutation, probability)
				@mutations << [mutation, probability]
				normalize_probabilities
				self
			end

			#	:call-seq:
			#		mutate(Individual) -> Individual
			#
			# Returns the mutation of a given individual using the added Mutations (one random member is choosen according
			# to its possiblity). If empty, it will return the Individual.
			#
			#     m = CombinedMutation.new([EvoSynth::Mutations::ShiftingMutation.new, EvoSynth::Mutations::MixingMutation.new])
			#     m.mutate(a_individual)   #=> a_new_individual

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

			#	:call-seq:
			#		to_s -> string
			#
			# Returns description of this mutation
			#
			#     m = CombinedMutation.new
			#     m.to_s		              #=> "combinded mutation <mutations: >"

			def to_s
				mutations_to_s = []
				@mutations.each { |mut| mutations_to_s << "#{mut[0].to_s} (probability: #{mut[1]})" }
				"combinded mutation <mutations: #{mutations_to_s.join(', ')}>"
			end

			private

			# this function normalizes the given probabilities between 0.0 and 1.0

			def normalize_probabilities
				sum = @mutations.inject(0.0) { |sum, mutation| sum += mutation[1] }

				if sum > 1.0
					subtract = (sum - 1.0) / (@mutations.size)
					@mutations.each { |mutation| mutation[1] -= subtract }
				end
			end
		end

	end
end