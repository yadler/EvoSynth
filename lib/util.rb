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

module EvoSynth

	module Util

		# Simple multidimensional Array

		class MDArray

			def initialize(rows, columns, initial_data = nil)
				@row_count = rows
				@col_count = columns
				@data = Array.new(@row_count * @col_count, initial_data)
			end

			def [](row, col)
				if row >= @row_count || col >= @col_count
					raise IndexError
				end

				@data[row * @col_count + col]
			end

			def []=(row, col, data)
				if row >= @row_count || col >= @col_count
					raise IndexError
				end

				@data[row * @col_count + col] = data
			end

			def to_s
				@data.to_s
			end

		end

	end


	private


	#FIXME: there should be a better way to clone a object!
	def EvoSynth.deep_copy( object )
		Marshal.load( Marshal.dump( object ) )
	end

end