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

	# Binary genome which keeps track of changes (changed attribute)
	# to reduce the need to recalculate the fitness function (see Evaluator)
	#
	# This genome is a simple bitstring and each gene is a boolean.
	#
	# FIXME: implment in C for better performance - right now its pretty useless
	# TODO: complete documentation

	class BinaryGenome
		include EvoSynth::Genome

		# Creates a BinaryGenome with a given initial (Integer) value. Default constructs a new
		# BinaryGenome with the initial value of 0.

		def initialize(intial_value = 0)
			@data = intial_value
			@changed = true
		end

		# Returns a clone of this genome

		def clone
			my_clone = BinaryGenome.new(@data)
			my_clone.changed = false
			my_clone
		end

		# Array like index accessor
		#
		# [index]
		# [index, length]
		# [range]

		def [](*args)
			if args.size == 1

				case args[0]
					when Numeric
						@data[args[0]]
					when Range
						get_sub_range args[0]
					else
						raise ArgumentError, "argument should be either index or range"
					end

			elsif args.size == 2
				get_sub_range Range.new(args[0], args[0] + args[1] - 1)
			else
				raise ArgumentError, "wrong number of arguments"
			end
		end

		# Array like index accessor

		def []=(*args)
			if args.size == 2

				case args[0]
					when Numeric
						set_gene(args[0], args[1])
					when Range
						case args[1]
							when Numeric
								args[0].each { |index| set_gene(index, args[1]) }
							when Array
								offset = args[0].begin
								args[0].each { |index| set_gene(index, args[1][index - offset]) }
							else
								raise ArgumentError, "argument (1) should be either index or range"
						end

					else
						raise ArgumentError, "argument (0) should be either index or range"
					end

			elsif args.size == 3
				args[1].times { |offset| set_gene(args[0] + offset, args[2]) }
			else
				raise ArgumentError, "wrong number of arguments"
			end
		end

		# Flips (inverts) the gene at the given index

		def flip!(index)
			@data = @data ^ (1 << index)
		end

		# Returns the size (in bits) of this genome.

		def size
			@size = @data.to_s(2).size unless defined? @size
			@size
		end

		# Return a printable version of the genome

		def to_s
			@data.to_s(2)
		end

		private

		def get_sub_range(range)
			subarray = []
			range.each { |index| subarray << @data[index] }
			subarray
		end

		def set_gene(index, gene)
			if gene == 0
				@data = @data ^ (1 << index) unless @data[index] == 0
			else
				@data = @data | (1 << index)
			end
		end
	end

end