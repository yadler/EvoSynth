#    Copyright (C) 2009, 2010 Yves Adler <yves.adler@googlemail.com>
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


module EvoSynth
	module Algorithms

		# POPULATIONSBASIERTES-BINÄRES-HILLCLIMBING (Weicker Page 65)

		class PopulationHillclimber
			include EvoSynth::Algorithms::Algorithm

			attr_accessor :mutation

			def initialize(population)
				@population = population
				@mutation = EvoSynth::Mutations::OneGeneFlipping.new
			end

			def to_s
				"population based hillclimber <mutation: #{@mutation}>"
			end

			private

			def best_solution
				@population.best
			end

			def return_result
				@population
			end

			def next_generation
				@population.map! { |individual| mutate(individual) }
			end

			def mutate(individual)
				child = @mutation.mutate(individual)
				child > individual ? child : individual
			end

		end

	end
end
