# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'parallel_map'
require 'benchmark'

# ParallelMap.patch Range
# ParallelMap.patch Array

def report_gain(subject, count, serial, parallel)
  return unless ENV['DEBUG'] == 'true'

  ratio = parallel / serial * 100.0
  gain  = 100 - ratio
  ary   = [subject.class.name, count, parallel, serial, ratio, gain]
  puts format 'Subject : %s | Count: %2i | Parallel: %3.2f | Serial : %3.2f | ratio : %3.2f%% | gain : %3.2f%%', *ary
end
