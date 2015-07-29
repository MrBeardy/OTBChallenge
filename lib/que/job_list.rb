module Que
  class JobList
    def initialize(jobs = [])
      @jobs = generate_jobs(jobs)
    end

    def <<(job)
      @jobs << job
    end

    # Find a Job in the JobList with the passed ID.
    def find_by_id(id)
      @jobs.find { |job| job.id == id }
    end

    # Returns true/false depending on if the JobList contains a Job with the ID.
    def include?(id)
      !!find_by_id(id)
    end

    # Creates a TSortableHash for all of the jobs and dependencies and returns
    # the TSorted array
    def tsort_ids
      begin
        @jobs.each_with_object(unsorted = TSortableHash.new(0)) do |job, hash|
          hash[job.id] = job.dependencies
        end

        unsorted.tsort
      rescue TSort::Cyclic
        fail CyclicDependencyError, "Jobs cannot have Cyclic dependencies."
      end
    end

    # Takes a TSorted array and replaces the IDs with Job instances from @jobs.
    def tsort
      tsort_ids.each_with_object([]) do |id, arr|
        arr << find_by_id(id)
      end
    end

    # Permanently TSorts the jobs array
    def tsort!
      @jobs = tsort
    end

    def length
      @jobs.length
    end

    def select(*args, &block)
      @jobs.select(*args, &block)
    end

    def to_a
      @jobs
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
