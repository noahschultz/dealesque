# need to load before anything else for coverage to work
require 'simplecov'
require 'simplecov-rcov'

# other dependencies
require 'vacuum'
require 'yaml'
require 'ostruct'
require 'rspec/given'
require 'json_spec'
require 'vcr'
require 'surrogate/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

# Requires all extra / autoload paths, @see /config/initializers/auto_require.rb
# Recommendation: do not rely on autoload for domain objects, use this just for specs
unless defined?(Rails)
  %W(
    lib
    app/lib
    app/values
    app/representers
    app/services
    app/use_cases
  ).each do |autoload_path|
    Dir[File.expand_path("../../#{autoload_path}/**/*.rb", __FILE__)].each { |f| require f }
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  # https://relishapp.com/vcr/vcr/docs/configuration/hook-into
  c.hook_into :excon, :faraday, :webmock # Vacuum uses Excon, Mechanize Net::Http
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  # disable should syntax, it wil become obsolete in future RSpec releases
  # http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  config.expect_with :rspec do |c|
    # don't force yet, surrogate gem requires the older syntax
    c.syntax = [:should, :expect] # :expect
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # https://github.com/collectiveidea/json_spec
  config.include JsonSpec::Helpers
end
