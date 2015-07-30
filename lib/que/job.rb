module Que

  # Holds information for a single job, including IDs for any dependencies.
  class Job
    attr_reader :id, :dependencies

    def initialize(id, dependencies = [], &block)
      @id, @dependencies = id, Array(dependencies)

      @proc = block if block_given?
    end

    def run
      if @proc
        @proc.call
      else
        @id
      end
    end

    def has_dependencies?
      !(dependencies.nil? || dependencies.empty?)
    end

    def has_self_dependency?
      dependencies.include? @id
    end
  end
end
