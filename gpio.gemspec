Gem::Specification.new do |s|
  s.name          = 'gpio'
  s.version       = '0.2'
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

  s.add_dependency 'path', '~> 2.0'

  s.add_development_dependency 'rake', '~> 13.0'
end