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


require 'observer'


require 'evosynth/core/logger/dataset'
require 'evosynth/core/logger/datafetcher'


module EvoSynth

	# customizable (column based) logger
	#
	#	logger = EvoSynth::Output::Logger.new(10, true,
	#		"gen" => ->{ evolver.generations_computed },
	#		"best" => ->{ configuration.population.best.fitness },
	#		"worst" => ->{ configuration.population.worst.fitness }
	#	)
	#	evolver.add_observer(logger)

	class Logger
		include Observable

		DEFAULT_COLUMNS = {
			:time						=> ->(observable) { Time.now },

			:eval_called				=> ->(evaluator) { evaluator.called },
			:eval_calculated			=> ->(evaluator) { evaluator.calculated },

			:evolver_eval_called		=> ->(evolver) { evolver.evaluator.called },
			:evolver_eval_calculated	=> ->(evolver) { evolver.evaluator.calculated },

			:gen						=> ->(evolver) { evolver.generations_computed },
			:best_to_s					=> ->(evolver) { evolver.best_solution?.to_s },
			:worst_to_s					=> ->(evolver) { evolver.worst_solution?.to_s },

			:best_fitness				=> ->(evolver) { evolver.best_solution?.fitness },
			:worst_fitness				=> ->(evolver) { evolver.worst_solution?.fitness },
			
			:pop_mean_fitness			=> ->(evolver) { EvoSynth::EvoBench.population_fitness_mean(evolver.population) },
			:pop_median_fitness			=> ->(evolver) { EvoSynth::EvoBench.population_fitness_median(evolver.population) },
			
			:pop_diversity_subseq		=> ->(evolver) { EvoSynth::EvoBench.diversity_subseq(evolver.population) },
			:pop_diversity_entropy		=> ->(evolver) { EvoSynth::EvoBench.diversity_entropy(evolver.population) },
			:pop_diversity_dist_float	=> ->(evolver) { EvoSynth::EvoBench.diversity_distance_float(evolver.population) },
			:pop_diversity_dist_hamming	=> ->(evolver) { EvoSynth::EvoBench.diversity_distance_hamming(evolver.population) }
		}

		attr_accessor :save_data
		attr_reader :data, :data_fetcher

		def initialize(log_step, save_data = true, things_to_log = {})
			@log_step = log_step
			@save_data = save_data

			@data_fetcher = EvoSynth::Logging::DataFetcher.new
			@data = EvoSynth::Logging::DataSet.new

			things_to_log.each_pair  { |name, lambda| add_column(name, lambda) }

			yield self if block_given?
		end

		# Returns a deep_copy of this object

		def deep_clone
			my_clone = self.clone
			my_clone.instance_variable_set(:@data_fetcher, @data_fetcher.deep_clone)
			my_clone.instance_variable_set(:@data, @data.deep_clone)
			my_clone
		end

		def add_column(column_name, column_lambda)
			@data_fetcher.add_column(column_name, column_lambda)
			@data.column_names << column_name
		end

		def clear_data!
			@data = EvoSynth::Logging::DataSet.new(@data.column_names)
		end

		def update(observable, key)
			return unless key % @log_step == 0

			new_row = @data_fetcher.fetch_next_row(observable)
			@data[key] = new_row if @save_data

			changed
			notify_observers self, key, new_row
		end

		# little logger factory
		#
		# WARNING: defaults will only work in combination with a evolver, not with a evaluator!
		# 
		# examples:
		# 
		# EvoSynth::Logger.create(25, false, :gen,:best_fitness, :worst_fitness, :pop_diversity_subseq)
		# 
		# logger = EvoSynth::Logger.create(50, true, :gen, :best_fitness, :worst_fitness) do |log|
		#    log.add_column("sigma",    ->(evolver) { evolver.sigma })
		#    log.add_column("success",  ->(evolver) { evolver.success })
		#    log.add_column("s",        ->(evolver) { evolver.s.inspect })
		# end
		#

		def Logger.create(step, console_output, *columns)
			logger = EvoSynth::Logger.new(step)
			logger.add_observer(EvoSynth::Export::ConsoleWriter.new) if console_output

			columns.each do |col|
				raise "unknown column name '#{col}'" unless DEFAULT_COLUMNS.has_key?(col)
				logger.add_column(col, DEFAULT_COLUMNS[col])
			end

			yield logger if block_given?
			logger
		end
	end

end