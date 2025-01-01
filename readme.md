# Jekyll file hash filter

Exposes a new filter called `hash_file` that enables you to perform automated cache busting via file name versioning. Cache busting is a technique to force the browser to load the most recent version of a file. The file is renamed to a hash that is based on the content of the file. The output of the filter is the new path of the file. A side effect of the filter is to copy the file and rename it. The renamed files are cached to prevent unnecessary disk interactions that can be relatively slow.

As an example, it turns this source code:

```liquid
  <script defer type="text/javascript" src="{{ "/scripts/main.js" | hash_file }}"></script>
```

Into the following HTML:

```html
<script
  defer=""
  type="text/javascript"
  src="/cache/hashed-files/f69a4d50f20bb781f908db2b2b2c7739.js"
></script>
```

## Installation

Add this line to your site's Gemfile:

```ruby
# If you have any plugins, put them here!
group :jekyll_plugins do

    # (...)

    gem 'jekyll-hash-file'
end
```

:warning: If you are using Jekyll < 3.5.0 use the `gems` key instead of `plugins`.

## References

Various topics about cache busting:

- [What is Cache Busting by KeyCDN](https://www.keycdn.com/support/what-is-cache-busting)
- [Cache Busting: A Guide to Keeping Your Website’s Content Fresh by Netlify](https://nestify.io/blog/cache-busting-techniques/)

### Guides

- [Your first Jekyll plugin](https://perseus333.github.io/blog/jekyll-first-plugin)

### Similar projects

- [Jekyll Resize](https://github.com/MichaelCurrin/jekyll-resize)
