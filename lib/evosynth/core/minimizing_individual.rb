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

	# Basic individual for for minimizing problems

	class MinimizingIndividual < Individual

		#	:call-seq:
		#		MinimizingIndividual.new -> MinimizingIndividual
		#		MinimizingIndividual.new(genome) -> MinimizingIndividual (with given genome)
		#
		# Returns a new MinimizingIndividual. In the first form, the genome is nil. In the second it
		# creates a MinimizingIndividual with the given genome.
		#
		#     EvoSynth::MinimizingIndividual.new
		#     EvoSynth::MinimizingIndividual.new( EvoSynth::ArrayGenome.new(10) { EvoSynth.rand_bool } )

		def initialize(genome = nil)
			super(genome)
			@fitness = Float::MAX
		end

		#	:call-seq:
		#		compare_fitness_values(one, two) -> Number
		#
		# Compares two fitness values for minimizing problems. It uses the <=> of the given
		# fitness values and inverts the result.

		def compare_fitness_values(one, two)
			-1 * (one <=> two)
		end

		#	:call-seq:
		#		to_s -> string
		#
		# Returns description of this individual
		#
		#     i = EvoSynth::MinimizingIndividual.new
		#     i.to_s                                     #=> "minimizing individual <fitness = 1.79769313486232e+308, genome = [nil]>"

		def to_s
			"minimizing individual <fitness = #{fitness}, genome = [#{genome}]>"
		end

	end

end