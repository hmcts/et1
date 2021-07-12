require_relative './base_page'
module ET1
  module Test
    class SaveAndCompleteLaterPage < BasePage

      def with(email_address:)
        email_address_element.set(email_address)
        sign_out_now_button.submit
      end

      def sign_out_now
        sign_out_now_button.submit
      end

      private


      # @!method memorable_word_element
      #   A govuk text field component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :email_address_element, govuk_component(:text_field), :govuk_text_field, :'save_and_complete_later.email_address.label'
      section :sign_out_now_button, govuk_component(:submit), :govuk_submit, :'save_and_complete_later.sign_out_now'
    end
  end
end
