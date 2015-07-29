module Que

  # Parses formatted input.
  class Parser
    STR_FORMAT = /(\w)\s*=>\s*(\w)?/m

    def self.from_string(str)
      str.lines.each_with_object([]) do |line, arr|
        unless (match = line.scan(STR_FORMAT)).empty?
          arr << match.flatten
        end
      end
    end
  end
end
