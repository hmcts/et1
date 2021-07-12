Capybara.add_selector(:link_or_button_translated) do
  label 'Link or button translated'
  xpath do |locator, **options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    @definition.label("Link or button translated <#{locator}>")
    expression_for(:link_or_button, translated, **options)
  end
end
