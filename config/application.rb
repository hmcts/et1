require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'London'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'en', '**', '*.{rb,yml}').to_s,
      Rails.root.join('config', 'locales', 'cy', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    # config.active_record.schema_format = :sql
    config.autoload_paths += Dir["#{config.root}/app/{services,forms,forms/concerns,presenters,validators}"]

    # Application Title (Populates <title>)
    config.app_title = 'Employment Tribunals'
    # Proposition Title (Populates proposition header)
    config.proposition_title = 'Employment Tribunals'
    # Current Phase (Sets the current phase and the colour of phase tags)
    # Presumed values: alpha, beta, live
    config.phase = 'live'
    # Product Type (Adds class to body based on service type)
    # Presumed values: information, service
    config.product_type = ''
    # Feedback URL (URL for feedback link in phase banner)
    config.feedback_url = ''
    # Controlls how many additional respondents are allowed
    config.additional_respondents_limit = 4

    config.assets.enabled = false

    config.assets.precompile += [
      'application-ie.css',
      'application-ie6.css',
      'application-ie7.css',
      'application-ie8.css',
      '*.png'
    ]

    config.cache_store = :memory_store

    config.action_mailer.default_options = { from: ENV.fetch('SMTP_FROM', 'no-reply@employmenttribunals.service.gov.uk') }
    config.secure_session_cookie = false
    config.exceptions_app = routes

    role_suffix = Sidekiq.server? ? '-SIDEKIQ' : ''
    insights_key = ENV.fetch('AZURE_APP_INSIGHTS_KEY', false)
    if insights_key
      config.azure_insights.enable = true
      config.azure_insights.key = insights_key
      config.azure_insights.role_name = ENV.fetch('AZURE_APP_INSIGHTS_ROLE_NAME', 'et1') + role_suffix
      config.azure_insights.role_instance = ENV.fetch('HOSTNAME', 'all')
      config.azure_insights.buffer_size = 500
      config.azure_insights.send_interval = 60
    else
      config.azure_insights.enable = false
    end
    config.x.cookie_expiry = 1.year
  end
end
