module QQ
  # Holds information for a single job, including IDs for any dependencies.
  class Job
    attr_reader :id, :dependencies

    def initialize(id, dependencies = [], &block)
      @id = id
      @dependencies = Array(dependencies)

      @proc = block if block_given?

      ensure_no_self_dependencies
    end

    def run
      if @proc
        @proc.call
      else
        @id
      end
    end

    def dependencies?
      !(dependencies.nil? || dependencies.empty?)
    end

    def self_dependent?
      dependencies.include? @id
    end

    def to_s
      "Job -> #{id}: #{dependencies}"
    end

    private

    # Fail on any self-depenent jobs
    def ensure_no_self_dependencies
      if self_dependent?
        fail SelfDependencyError,
             "Jobs can't depend upon themselves.\n\t#{self}\n\n"
      end
    end
  end
end
