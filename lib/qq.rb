require_relative 'qq/all'

module QQ
  class CyclicDependencyError < StandardError; end
  class SelfDependencyError < StandardError; end
  class NonExistentDependencyError < StandardError; end

  # Forward any missing methods over to Que::Queue
  # TODO: implement a more concrete solution.
  def self.method_missing(method, *args, &block)
    Queue.method(method).call(*args, &block)
  end
end
