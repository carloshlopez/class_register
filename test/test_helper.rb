ENV['RAILS_ENV'] ||= 'test'
ENV['HERMES_API_TOKEN'] ||= 'test-hermes-token'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
