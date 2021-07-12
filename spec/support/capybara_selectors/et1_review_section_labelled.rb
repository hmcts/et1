Capybara.add_selector(:et1_review_section_labelled) do
  label 'GOVUK GDS check answer page section labelled'
  xpath do |locator, _options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS check answer page section labelled <#{translated}>")
    XPath.generate do |x|
      x.descendant(:dl)[x.attr(:class).contains_word('govuk-summary-list') & x.preceding_sibling(:h2)[1][x.string.n.starts_with(translated)]]
    end
  end
end
