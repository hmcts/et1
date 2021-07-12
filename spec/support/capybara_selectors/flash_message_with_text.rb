Capybara.add_selector(:flash_message_with_text) do
  xpath do |locator, _options|
    XPath.generate { |x| x.descendant(:p)[x.ancestor(:div)[x.attr(:class).contains_word('flash').and(x.string.equals(locator))]] }
  end
end
