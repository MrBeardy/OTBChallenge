module QQ
  # Holds information for a single job, including IDs for any dependencies.
  class Job
    attr_reader :id, :dependencies

    def initialize(id, dependencies = [], &block)
      @id = id
      @dependencies = Array(dependencies)

      @proc = block if block_given?
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
  end
end
