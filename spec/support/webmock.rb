require 'webmock/rspec'
require_relative './capybara_driver_helper'
WebMock.disable_net_connect!(allow_localhost: true, allow: ['chromedriver.storage.googleapis.com'])
