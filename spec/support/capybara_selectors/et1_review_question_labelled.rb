Capybara.add_selector(:et1_review_question_labelled) do
  xpath do |locator, _options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    XPath.generate do |x|
      x.descendant(:div)[x.attr(:class).contains_word('govuk-summary-list__row') & x.child(:dt)[x.attr(:class).contains_word('govuk-summary-list__key') & x.string.n.equals(translated)]]
    end
  end
end
