source 'https://rubygems.org'
gemspec

gem 'base64'
gem 'rake'
gem 'json'

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
end

group :test do
  gem 'rexml'
  gem 'rspec',    '~> 3.4'
  # Emit JUnit XML so CircleCI's store_test_results can detect the flaky spec.
  gem 'rspec_junit_formatter', '~> 0.6'
  gem 'simplecov', require: false
  gem 'webmock'
  gem 'addressable'
end

group :development, :test do
  gem 'pry'
end
