require 'capybara/poltergeist'
Capybara.configure do |config|
  config.default_max_wait_time =15
  config.javascript_driver = :chromevisible
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, timeout: 60)
end

Capybara.register_driver :chromevisible do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--start-maximized')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.server = :webrick
