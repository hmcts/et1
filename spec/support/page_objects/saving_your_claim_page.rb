require_relative './base_page'
module ET1
  module Test
    class SavingYourClaimPage < BasePage
      set_url "/en/apply/application-number"

      # @return [String] The claim number assigned to you
      def claim_number

      end

      # Registers the user for a save and return
      def register(email_address: '', password:)
        email_address_question.set(email_address)
        memorable_word_question.set(password)
        save_and_continue_element.click
      end

      private

      section :email_address_question, :question_labelled_translated, 'saving_your_claim.email_address' do
        def set(value)
          input.set(value)
        end

        private

        element :input, :css, 'input'
      end

      section :memorable_word_question, :question_labelled_translated, 'saving_your_claim.memorable_word' do
        def set(value)
          input.set(value)
        end

        private

        element :input, :css, 'input'
      end

      element :save_and_continue_element, :link_or_button_translated, 'saving_your_claim.save_and_continue'
    end
  end
end
