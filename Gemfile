source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'jquery-rails'
gem 'haml-rails'
gem 'dalli'
gem 'thin'

# Amazon Product Advertising API support
gem 'vacuum'
gem 'representable'
gem 'roar'
gem 'roar-rails'
gem 'virtus'
gem 'mechanize'
gem 'money'

# other
gem 'wisper', '~>1.0.0'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
  gem 'twitter-bootstrap-rails'
end

group :development, :test do
  gem 'therubyracer', :platforms => :ruby # https://devcenter.heroku.com/articles/rails3x-asset-pipeline-cedar
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-given'
  gem 'json_spec'
  gem 'surrogate'
  gem 'vcr'
  gem 'jeff', '= 0.6.2' # see excon gem details below
  gem 'excon' # use older jeff gem, this will force older excon, the one supported by vcr
  gem 'faraday'
  gem 'webmock', '<  1.10.0' # use this until vcr supports latest versions
end

group :development do
  gem 'ci_reporter'
  gem 'simplecov'
  gem 'simplecov-rcov'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'sextant'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
