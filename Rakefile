GEMSPEC = "hash-file.gemspec"

task :build do
  BIN_FOLDER = "bin"

  # Create the bin folder if it does not yet exist
  FileUtils.mkdir_p(BIN_FOLDER)

  # Clear out all files in the bin folder
  FileUtils.rm_r("#{BIN_FOLDER}/*", force: true)

  # Build the gem
  system("gem build #{GEMSPEC}")
  version = Gem::Specification::load(GEMSPEC).version

  # Move the artifact into the bin folder
  File.rename("jekyll-hash-file-#{version}.gem", "#{BIN_FOLDER}/jekyll-hash-file.gem")
end

task :install => :build do
  # Uninstall and install the gem
  package_name = Gem::Specification::load(GEMSPEC).name
  system("gem uninstall #{package_name}")
  system("gem install bin/#{package_name}.gem")
end