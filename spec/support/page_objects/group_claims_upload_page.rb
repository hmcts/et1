require_relative './base_page'
module ET1
  module Test
    class GroupClaimsUploadPage < BasePage
      set_url "/en/apply/additional-claimants-upload"


      # Uploads the secondary claimants csv file
      # @param [String] csv_file The full path to the csv file to upload
      def upload_secondary_claimants_csv(csv_file)
        people_making_claim_with_you_question.set(:'group_claims_upload.people_making_claim_with_you.options.yes')
        upload_file_question.set(csv_file)
        self
      end

      # Switches to manual input by clicking on the link 'you can enter their details manually'
      def switch_to_manual_input
        switch_to_manual_input_element.click
      end

      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      def no_secondary_claimants
        people_making_claim_with_you_question.set(:'group_claims_upload.people_making_claim_with_you.options.no')
        self
      end

      def remove_csv_file
        remove_csv_file_question.set(true)
      end

      private

      # @!method govuk_radios
      #   A govuk radio button component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :people_making_claim_with_you_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'group_claims_upload.people_making_claim_with_you.label'

      # @!method upload_file_question
      #   A govuk file field component wrapping the input, label, hint etc.. for the upload file question
      #   @return [EtTestHelpers::Components::GovUKFileField] The site prism section
      section :upload_file_question, govuk_component(:file_field), :govuk_file_field, :'group_claims_upload.upload_spreadsheet.label'

      # @!method save_and_continue_button
      #   A govuk submit button component for the save and continue button
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :save_and_continue_button, govuk_component(:submit), :govuk_submit, :'group_claims_upload.save_and_continue'

      element :switch_to_manual_input_element, :link, t('group_claims_upload.switch_to_manual')

      # @!method remove_csv_file_question
      #   A govuk file field component wrapping the input, label, hint etc..
      #   @return [EtTestHelpers::Components::GovUKFileField] The site prism section
      section :remove_csv_file_question, govuk_component(:checkbox), :govuk_checkbox, :'group_claims_upload.remove_csv_file.label'

    end
  end
end
