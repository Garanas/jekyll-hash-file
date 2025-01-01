Gem::Specification.new do |s|
  s.name        = 'jekyll-hash-file'
  s.version     = '1.0.0'
  s.date        = '2024-12-31'
  s.summary     = 'Liquid filter to hash file references to bust the browser cache in Jekyll 3 and 4'
  s.description = ''
  s.authors     = ['Willem \'Jip\' Wijnia']
  s.files       = Dir["lib/**/*"]
  s.homepage    = 'https://github.com/Garanas/jekyll-hash-file'
  s.license     = 'MIT'

  s.required_ruby_version = ">= 3.0.0"

  s.add_dependency 'jekyll', '> 3.3', '< 5.0'
end
