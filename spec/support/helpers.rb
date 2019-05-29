Dir.glob(File.absolute_path('./helpers/**/*.rb', __dir__)).each do |f|
  require f
end

RSpec.configure do |c|
  c.include ET1::Test::Pages, type: feature
  c.include ET1::Test::Setup, type: feature
end

RSpec.configure do |c|
  c.before(:suite) do
    ET1::Test::AzureHelpers.configure_test_container
    ET1::Test::AzureHelpers.configure_cors
  end
end
