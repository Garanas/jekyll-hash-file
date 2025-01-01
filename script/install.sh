task :build do
  gemspec = 'my_gem.gemspec'
  system("gem build #{gemspec}")
  version = Gem::Specification::load(gemspec).version
  File.rename("my_gem-#{version}.gem", "custom_name.gem")
end