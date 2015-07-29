module Que

  # Holds information for a single job, including IDs for any dependencies.
  class Job
    attr_reader :id, :dependencies

    def initialize(id, dependencies = [])
      @id = id
      @dependencies = Array(dependencies)
    end

    def run
      # TODO: Add ability for jobs to run procs.

      @id
    end

    def has_dependencies?
      !(dependencies.nil? || dependencies.empty?)
    end
  end
end
