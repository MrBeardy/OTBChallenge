require_relative 'Que/all'

module Que
  class CyclicDependencyError < StandardError; end

  # Forward any missing methods over to Que::Queue
  # TODO: implement a more concrete solution.
  def self.method_missing(method, *args)
    Queue.method(method).call(*args)
  end
end
