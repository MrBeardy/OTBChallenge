require_relative 'que/all'

module Que
  class SelfDependenceError < StandardError; end

  # Forward any missing methods over to Que::Queue
  # TODO: implement a more concrete solution.
  def self.method_missing(method, *args)
    Queue.method(method).call(*args)
  end
end
