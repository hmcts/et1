module ET1
  module Test
    class CheckboxQuestionSection < BaseSection
      def set(value)
        input.set value
      end

      def assert_error_message(text)
        error_message_element(text: text)
      end

      private

      element :input, :css, 'input[type=checkbox]'
      element :error_message_element, :css, 'span.error'
    end
  end
end
