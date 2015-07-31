require 'coveralls'
require 'qq'

Coveralls.wear!

RSpec.configure do |config|
  config.color = true
  config.formatter = 'documentation'
end
