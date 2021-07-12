require_relative './base_page'
module ET1
  module Test
    class AboutTheClaimPage < BasePage
      set_url "/en/apply/claim-type"


      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      # @param [ET1::Test::ClaimTypeUi] claim_type The claim type data from the user
      def fill_in_all(claim_type:)
        unfair_dismissal_question.set(claim_type.claim_types.select { |ct| ct.to_s =~ %r{claim_type.unfair_dismissal} })
        discrimination_question.set(claim_type.claim_types.select { |ct| ct.to_s =~ %r{claim_type.discrimination} })
        pay_question.set(claim_type.claim_types.select { |ct| ct.to_s =~ %r{claim_type.pay} })
        other_question.set(claim_type.claim_types.select { |ct| ct.to_s =~ %r{claim_type.other} })
        claim_type_other_details_question.set(claim_type.claim_type_other_details)
        whistle_blowing_fieldset.tap do |section|
          section.whistle_blowing_question.set(claim_type.is_whistleblowing)
          section.whistle_blowing_body_question.set(claim_type.whistleblowing_forward_claim)
        end
      end

      def assert_questions
        expect(page).not_to have_text("Unfair dismissal (including constructive dismissal) (optional)", wait: false)
        expect(page).to have_text("Unfair dismissal (including constructive dismissal)")

        expect(page).not_to have_text("Other type of claim (optional)", wait: false)
        expect(page).to have_text("Other type of claim")

        expect(page).not_to have_text("Are you reporting suspected wrongdoing at work? (optional)", wait: false)
        expect(page).to have_text("Are you reporting suspected wrongdoing at work?")
        self
      end

      # @!method unfair_dismissal_question
      #   A govuk collection of checkboxes component for unfair dismissal question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      section :unfair_dismissal_question, govuk_component(:collection_check_boxes), :govuk_collection_check_boxes, :'claim_type.unfair_dismissal.label'

      # @!method discrimination_question
      #   A govuk collection of checkboxes component for discrimination question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      section :discrimination_question, govuk_component(:collection_check_boxes), :govuk_collection_check_boxes, :'claim_type.discrimination.label'

      # @!method pay_question
      #   A govuk collection of checkboxes component for discrimination question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      section :pay_question, govuk_component(:collection_check_boxes), :govuk_collection_check_boxes, :'claim_type.pay.label'

      # @!method other_question
      #   A govuk collection of checkboxes component for other type of claim question
      #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      section :other_question, govuk_component(:collection_check_boxes), :govuk_collection_check_boxes, :'claim_type.other.label'

      # @!method claim_type_other_details_question
      #   A govuk text area component wrapping the input, label, hint etc.. for the 'State the other type of claim that you are making'
      #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
      section :claim_type_other_details_question, govuk_component(:text_area), :govuk_text_area, :'claim_type.claim_type_other_details.label'

      section :whistle_blowing_fieldset, :govuk_fieldset, :'claim_type.is_whistleblowing.heading' do
        include EtTestHelpers::Section

        # @!method whistle_blowing_question
        #   A govuk radio button component for whistle blowing question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :whistle_blowing_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'claim_type.is_whistleblowing.label'

        # @!method whistle_blowing_body_question
        #   A govuk radio button component for whistle blowing send to body question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        section :whistle_blowing_body_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'claim_type.send_claim_to_whistleblowing_entity.label'
      end

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :save_and_continue_button, govuk_component(:submit), :govuk_submit, :'claim_type.save_and_continue'
    end
  end
end
