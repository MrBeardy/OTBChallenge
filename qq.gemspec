$:<< File.dirname(File.expand_path("../lib/qq", __FILE__))
require "qq/version"

Gem::Specification.new do |s|
  s.name          = "qq"
  s.version       = QQ::VERSION
  s.authors       = ["Michael Hibbs"]
  s.email         = ["hibbs.michael@gmail.com"]
  s.description   = %q{QQ is a small library that takes a formatted string (or multi-dimensional array) as input and stores it as Jobs with optional dependencies.}
  s.summary       = %q{QQ - A small library that handles dependency-driven jobs.}
  s.homepage      = ""

  s.files         = Dir['LICENSE', 'README.md', 'lib/**/*', 'bin/*']
  s.executables   = ['qq']
  s.require_paths = ['lib']
  s.licenses      = ['MIT']

  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency 'rspec'
end
