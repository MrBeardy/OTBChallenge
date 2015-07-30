module Que

  # Holds information for a single job, including IDs for any dependencies.
  class Job
    attr_reader :id, :dependencies

    def initialize(id, dependencies = [])
      @id, @dependencies = id, Array(dependencies)
    end

    def run
      # TODO: Add ability for jobs to run procs.

      @id
    end

    def has_dependencies?
      !(dependencies.nil? || dependencies.empty?)
    end

    def has_self_dependency?
      dependencies.include? @id
    end
  end
end
