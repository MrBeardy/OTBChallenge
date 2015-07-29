module Que

  # Holds instances of Jobs, which can be run
  # in order of dependence.
  class Queue
    attr_accessor :jobs

    def initialize(jobs = [])
      @jobs = generate_jobs(jobs)
    end

    # Generate a new Que object by passing
    # in a formatted string.
    def self.from_string(str = "")
      new(Parser.from_string(str))
    end

    # Returns an array of Jobs ordered by dependency
    def ordered_jobs
      
    end

    private

    # Create Job instances for each of the jobs.
    def generate_jobs(jobs)
      jobs.each_with_object([]) do |(id, dependencies), jobs|
        jobs << Job.new(id, dependencies)
      end
    end
  end
end
