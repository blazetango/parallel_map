# frozen_string_literal: true
require 'parallel_map/version'
require 'concurrent'

module ParallelMap
  # @!method pmap
  #
  #   Parallel #map for any Enumerable.
  #
  #   When a block is given, each item is yielded to the block in a
  #   separate thread. When no block is given, an Enumerable is
  #   returned.
  #
  #   @see http://ruby-doc.org/core-2.2.3/Enumerable.html#method-i-map
  #
  #   @return [Array] of mapped objects
  #

  def self.included(base)
    base.class_eval do
      # @see PMap#pmap
      def pmap(&proc)
        return self unless proc

        Concurrent::Array.new.tap do |results|
          each do |item|
            results << Concurrent::Future.execute { yield item }
          end
        end.map(&:value)
      end
    end
  end

  def patch(module_or_class)
    module_or_class.send :include, ParallelMap
  end

  module_function :patch

  def patch_enumerable
    patch ::Enumerable
  end

  module_function :patch_enumerable
end
