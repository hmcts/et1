Capybara.add_selector(:et1_review_additional_claimant_labelled) do
  xpath do |locator, _options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    XPath.generate do |x|
      x.descendant(:dl)[x.attr(:class).contains_word('govuk-summary-list') & x.child(:h2)[x.string.n.starts_with(translated)]]
    end
  end
end
