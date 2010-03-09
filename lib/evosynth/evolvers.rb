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


require 'evosynth/evolvers/evolver'
require 'evosynth/evolvers/elitism'

require 'evosynth/evolvers/basic/hillclimber'
require 'evosynth/evolvers/basic/population_hillclimber'
require 'evosynth/evolvers/basic/genetic_algorithm'
require 'evosynth/evolvers/basic/steady_state_ga'
require 'evosynth/evolvers/basic/memetic_algorithm'

require 'evosynth/evolvers/evolution_strategies/adaptive_es'
require 'evosynth/evolvers/evolution_strategies/selfadaptive_es'
require 'evosynth/evolvers/evolution_strategies/derandomized_es'

require 'evosynth/evolvers/local_search/local_search'

require 'evosynth/evolvers/coevolutionary/coop_coevolutionary'
require 'evosynth/evolvers/coevolutionary/cmb_coevolutionary'