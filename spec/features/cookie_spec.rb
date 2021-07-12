require 'rails_helper'

feature 'Cookies' do
let(:how_we_use_cookies_header)          { '<h2 class="legend">How cookies are used</h2>' }
let(:measuring_website_usage_header)     { '<h3>Measuring website usage (Google Analytics)</h3>' }
let(:your_progress)                      { '<h3>Your progress when using the service</h3>' }

before do
visit edit_cookies_path
end

scenario "User visits the cookies page" do
expect(page.html).to include(how_we_use_cookies_header)
expect(page.html).to include(measuring_website_usage_header)
expect(page.html).to include(your_progress)
end

end
