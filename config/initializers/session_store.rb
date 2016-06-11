# Be sure to restart your server when you modify this file.

# Dealesque::Application.config.session_store :cookie_store, key: '_dealesque_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Dealesque::Application.config.session_store :active_record_store

# Store session data in what ever cache mechanism is used, see /config/environments/development.rb
Dealesque::Application.config.session_store :cache_store