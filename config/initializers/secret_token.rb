# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

class ConfigurationError < StandardError; end

secret_token_file = 'config/secret_token.yml'
secret_token = ENV['SECRET_TOKEN'] || YAML::load(File.open(secret_token_file))[Rails.env]['token'] if File.exists?(secret_token_file)
raise ConfigurationError.new("Could not load secret token from environment or #{File.expand_path(secret_token_file)}") unless secret_token

Dealesque::Application.config.secret_token = secret_token