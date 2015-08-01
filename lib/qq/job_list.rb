module QQ
  # Holds an array of jobs with ability to TSort them.
  class JobList
    def initialize(jobs = [])
      jobs = Parser.from_string(jobs) if jobs.is_a? String

      # TODO: Add fail-safe for symbols.

      @jobs = generate_jobs(jobs)

      ensure_no_unknown_dependencies
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
      find_by_id(id).nil?
    end

    # Creates a TSortableHash for all of the jobs and dependencies and returns
    # the TSorted array
    def tsort_ids
      @jobs.each_with_object(unsorted = TSortableHash.new(0)) do |job, hash|
        hash[job.id] = job.dependencies
      end

      unsorted.tsort
    rescue TSort::Cyclic => e
      raise CyclicDependencyError,
            "Jobs cannot have Circular dependencies: #{e}."
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

    def count(*args, &block)
      @jobs.count(*args, &block)
    end

    def select(*args, &block)
      @jobs.select(*args, &block)
    end

    def to_a
      @jobs
    end

    def ids
      @jobs.map(&:id).flatten.uniq
    end

    def dependencies
      @jobs.map(&:dependencies).flatten.uniq
    end

    private

    # Create Job instances for each of the jobs.
    def generate_jobs(jobs)
      jobs.each_with_object([]) do |(id, dependencies), arr|
        # Allow Job objects and Arrays to be interchanged.
        if id.is_a? Job
          arr << id
        else
          arr << Job.new(id, dependencies)
        end
      end
    end

    # Fail if any job depends on a non-existent job.
    def ensure_no_unknown_dependencies
      offending_jobs = dependencies.reject { |id| ids.include? id }

      unless offending_jobs.empty?
        fail NonExistentDependencyError,
             "Jobs can only depend on jobs that exist.\n\t#{offending_jobs}\n\n"
      end
    end
  end
end
