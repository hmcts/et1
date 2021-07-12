require_relative './base_page'
module ET1
  module Test
    class ClaimOutcomePage < BasePage
      set_url "/en/apply/claim-outcome"


      # @param [ET1::Test::ClaimOutcomeUi] claim_outcome The claim outcome data that the user submits
      # @return [ET1::Test::ClaimOutcomePage]
      def fill_in_all(claim_outcome:)
        what_do_you_want_question.set(claim_outcome.what_do_you_want)
        notes_question.set(claim_outcome.notes)
        self
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      private

      # @!method what_do_you_want_question
      #   A govuk collection of checkboxes component for what do you want question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      section :what_do_you_want_question, govuk_component(:collection_check_boxes), :govuk_collection_check_boxes, :'claim_outcome.what_do_you_want.label'

      # @!method notes_question
      #   A govuk text area component wrapping the input, label, hint etc.. for the 'What compensation or other outcome do you want?' question
      #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
      section :notes_question, govuk_component(:text_area), :govuk_text_area, :'claim_outcome.notes.label'

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :save_and_continue_button, govuk_component(:submit), :govuk_submit, :'claim_outcome.save_and_continue'
    end
  end
end
