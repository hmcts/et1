require_relative './base_page'
module ET1
  module Test
    class MoreAboutTheClaimPage < BasePage
      set_url "/en/apply/additional-information"


      # @param [ET1::Test::MoreAboutTheClaimUi] more_about_the_claim
      # @return [ET1::Test::MoreAboutTheClaimPage]
      def fill_in_all(more_about_the_claim:)
        provide_more_information_question.set(more_about_the_claim.provide_more_information)
        more_information_question.set(more_about_the_claim.more_information)
        self
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      private

      # @!method provide_more_information_question
      #   A govuk radio button component for 'Do you want to provide additional information about your claim?' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :provide_more_information_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'more_about_the_claim.provide_more_information.label'

      # @!method more_information_question
      #   A govuk text area component for the 'Enter more detail about your claim' question
      #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
      section :more_information_question, govuk_component(:text_area), :govuk_text_area, :'more_about_the_claim.more_information.label'

      # @!method save_and_continue_button
      #   A govuk submit button component... for the save and continue button
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :save_and_continue_button, govuk_component(:submit), :govuk_submit, :'more_about_the_claim.save_and_continue'
    end
  end
end
