require_relative '../base_page'
require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class ProfileSelectionPage < BasePage
        set_url "/en/apply/refund/profile-selection"
        # @!method select_profile_question
        #   A govuk radio button component for select profile question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :select_profile_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, 'You can apply for a refund of Employment Tribunal or Employment Appeal Tribunal Fees (or both) by confirming you are one of the following:'

        element :session_reloaded_message, :flash_message_with_text, 'Your session has been re loaded - this may have been caused by your cookie expiring'
        element :save_and_continue, 'input[value="Continue"]'
      end
    end
  end
end
