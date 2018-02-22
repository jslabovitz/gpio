require_relative 'lib/gpio/version'

Gem::Specification.new do |s|
  s.name          = 'gpio'
  s.version       = GPIO::VERSION
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'

  s.summary       = %q{GPIO does blah blah blah}
  # s.description   = %q{TODO: Write a longer description or delete this line.}
  s.homepage      = 'http://github.com/jslabovitz/gpio'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_dependency 'path', '~> 0'

  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rubygems-tasks', '~> 0.2'
end