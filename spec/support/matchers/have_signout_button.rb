RSpec::Matchers.define :have_signout_button do
  match { |page| page.has_link? 'Save and complete later' }
end
