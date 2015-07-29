module Que

  # Holds instances of Jobs, which can be run
  # in order of dependence.
  class Queue
    attr_reader :job_list

    def initialize(jobs = [])  
      @job_list = JobList.new(jobs)
    end

    # Convenience methods that interact with JobList
    def tsort
      @job_list.tsort
    end

    def tsort!
      @job_list.tsort!
    end

    def length
      @job_list.length
    end

    def run
      @job_list.tsort.each_with_object(order = '') do |job, _|
        order << job.run
      end
    end
  end
end
