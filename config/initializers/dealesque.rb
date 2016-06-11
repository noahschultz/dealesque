require 'yaml'

def get_credentials_from_environment
  {
      "key" => ENV['AMAZON_KEY'],
      "secret" => ENV['AMAZON_SECRET'],
      "tag" => ENV['AMAZON_TAG']
  }
end

def get_credentials_from_file
  credentials_file = 'config/amazon.yml'
  raise AmazonClientConfigurationError.new("Missing credentials file @ #{File.expand_path(credentials_file)})") unless File.exists?(credentials_file)
  YAML::load(File.open(credentials_file))[Rails.env]
end

begin
  credentials = get_credentials_from_environment
  AmazonClient.validate_credentials(credentials)
rescue AmazonClientConfigurationError
  credentials = get_credentials_from_file
  AmazonClient.validate_credentials(credentials)
end

AMAZON_CREDENTIALS = credentials
