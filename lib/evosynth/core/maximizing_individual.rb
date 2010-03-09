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

	# Class for Individuals (for maximizing problems)

	class MaximizingIndividual < Individual

		#	:call-seq:
		#		MaximizingIndividual.new -> MaximizingIndividual
		#		MaximizingIndividual.new(genome) -> MaximizingIndividual (with given genome)
		#
		# Returns a new MaximizingIndividual. In the first form, the genome is nil. In the second it
		# creates a MaximizingIndividual with the given genome.
		#
		#     EvoSynth::MaximizingIndividual.new
		#     EvoSynth::MaximizingIndividual.new( EvoSynth::ArrayGenome.new(10) { EvoSynth.rand_bool } )

		def initialize(genome = nil)
			super()
			@genome = genome
			@fitness = Float::MIN
		end

		#	:call-seq:
		#		compare_fitness_values(one, two) -> Number
		#
		# Compares two fitness values for maximizing problems. It uses the <=> of the given
		# fitness values.

		def compare_fitness_values(one, two)
			one <=> two
		end

		#	:call-seq:
		#		to_s -> string
		#
		# Returns description of this individual
		#
		#     i = EvoSynth::MaximizingIndividual.new
		#     i.to_s                                     #=> "maximizing individual <fitness = 2.2250738585072e-308, genome = [nil]>"

		def to_s
			"maximizing individual <fitness = #{fitness}, genome = [#{genome}]>"
		end

	end

end