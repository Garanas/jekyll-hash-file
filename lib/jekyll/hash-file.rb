require "digest"

module Jekyll
  module HashFile
    CACHE_DIR = "cache/hashed-files/"
    HASH_LENGTH = 32

    # Defines the hashes file name.
    # @param absolute_path_source [String] Full path to the source file
    # @return [String]
    def _compute_filename(absolute_path_source)
      hash = Digest::SHA256.file(absolute_path_source)
      short_hash = hash.hexdigest()[0, HASH_LENGTH]
      extension = File.extname(absolute_path_source)

      "#{short_hash}#{extension}"
    end

    # Compute all necessary paths for the plugin.
    # @param absolute_path_site [String] As an example: "C:/jekyll/jekyll-hash-file"
    # @param relative_path_source [String] As an example: "/assets/image-a.png" or "/assets/style/main.css"
    # @return [Array(String, String, String, String, String)]
    # * [String] absolute_path_source - Full path to the source file
    # * [String] absolute_path_destination - Full path to the destination file
    # * [String] absolute_path_cache - Full path to the cache directory
    # * [String] file_name_destination - Name of the destination file
    # * [String] relative_path_destination - Relative path to the destination file
    def _compute_paths(absolute_path_site, relative_path_source)
      absolute_path_source = File.join(absolute_path_site, relative_path_source)
      raise "No file found at #{absolute_path_source}" unless File.readable?(absolute_path_source)

      file_name_destination = _compute_filename(absolute_path_source)

      absolute_path_cache = File.join(absolute_path_site, CACHE_DIR)
      absolute_path_destination = File.join(absolute_path_cache, file_name_destination)
      relative_path_destination = File.join(CACHE_DIR, file_name_destination)

      [absolute_path_source, absolute_path_destination, absolute_path_cache, file_name_destination, relative_path_destination]
    end

    # Determine whether the file exists in the cache.
    # @param absolute_path_source [String] As an example: "C:/jekyll/jekyll-hash-file"
    # @param absolute_path_destination [String] As an example: "/assets/image-a.png" or "/assets/style/main.css"
    # @return [Boolean] If true, the file exists in the cache.
    def _in_cache? (absolute_path_source, absolute_path_destination)
      File.exist?(absolute_path_destination)
    end

    # Determine whether the file in the cache is still valid. It does so by comparing the modification times of the files.
    # @param absolute_path_source [String] As an example: "C:/jekyll/jekyll-hash-file"
    # @param absolute_path_destination [String] As an example: "/assets/image-a.png" or "/assets/style/main.css"
    # @return [Boolean] If true, the file should be skipped.
    def _valid_cache? (absolute_path_source, absolute_path_destination)
      File.mtime(absolute_path_destination) >= File.mtime(absolute_path_source)
    end

    # Creates a copy of the source file with a hashed name to for cache busting. Processed files are cached to speed up builds.
    # @param relative_source_path [String] As an example: "/assets/image-a.png" or "/assets/style/main.css"
    # @return [String] As an example: "f69a4d50f20bb781f908db2b2b2c7739.js"
    def hash_file(relative_source_path)

      site = @context.registers[:site]

      absolute_path_source, absolute_path_destination, absolute_path_cache, file_name_destination, relative_path_destination = _compute_paths(site.source, relative_source_path)

      # Create the cache directory
      FileUtils.mkdir_p(absolute_path_cache)

      if _in_cache?(absolute_path_source, absolute_path_destination) && _valid_cache?(absolute_path_source, absolute_path_destination)
        # if the file is cached and valid we can just return the relative path
        return relative_path_destination
      else
        # otherwise, we process the file and add it to the cache
        puts "Hashing '#{relative_source_path}' to '#{relative_path_destination}'"
        FileUtils.cp(absolute_path_source, absolute_path_destination)
        site.static_files << Jekyll::StaticFile.new(site, site.source, CACHE_DIR, file_name_destination)
      end

      relative_path_destination
    end
  end
end

Liquid::Template.register_filter(Jekyll::HashFile)
