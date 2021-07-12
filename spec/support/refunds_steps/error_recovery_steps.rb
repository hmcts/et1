def and_my_session_dissapears_from_a_timeout
  browser = Capybara.current_session.driver.browser
  driver = Capybara.current_session.driver
  if browser.respond_to?(:clear_cookies)
    # Rack::MockSession
    browser.clear_cookies
  elsif browser.respond_to?(:manage) && browser.manage.respond_to?(:delete_all_cookies)
    # Selenium::WebDriver
    browser.manage.delete_all_cookies
  elsif driver.respond_to?(:clear_cookies)
    driver.clear_cookies
  else
    raise "Don't know how to clear cookies. Weird driver?"
  end
end

def then_i_should_see_the_profile_selection_page_with_a_session_reloaded_message
  expect(refund_profile_selection_page).to have_session_reloaded_message
end
