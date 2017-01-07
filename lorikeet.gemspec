require_relative './lib/lorikeet/version'

Gem::Specification.new do |s|
  s.name     = 'lorikeet'
  s.summary  = 'Lorikeet'
  s.version  = Lorikeet::VERSION
  s.authors  = ['Steve Weiss']
  s.email    = ['weissst@mail.gvsu.edu']
  s.homepage = 'https://github.com/sirscriptalot/lorikeet'
  s.license  = 'MIT'
  s.files    = `git ls-files`.split("\n")
end
