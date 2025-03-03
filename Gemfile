source 'https://rubygems.org'

ruby '3.1.4'

gem 'rails', '~> 7.0'
gem 'pg', '>= 1.1', '< 2.0'  # Postgres adapter

gem 'puma', '~> 6.0'        # Compatible with Rack 3
gem 'jbuilder', '~> 2.7'    # JSON responses (API support)

# Modern Asset Pipeline replacements
gem 'jsbundling-rails'      # For JavaScript (esbuild/webpack/rollup)
gem 'cssbundling-rails'     # For CSS (Dart Sass, Tailwind, etc.)
gem 'turbo-rails'           # Hotwire (replaces Turbolinks)

# Optional but useful
gem 'bootsnap', require: false   # Speeds up boot
gem 'json-schema'                # Keep if you need JSON schema validation

group :development, :test do
  gem 'byebug'
end

group :development, :test do
  gem 'dotenv-rails'
end


group :development do
  gem 'web-console'
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0'
end
