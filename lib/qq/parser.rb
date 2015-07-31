module QQ

  # Parses formatted input.
  class Parser
    STR_FORMAT = /(\w)\s?=>\s?(\w)?;?/m

    def self.from_string(str)
      str.scan(STR_FORMAT)
    end
  end
end
