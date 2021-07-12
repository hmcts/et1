require_relative './page_objects'
module ET1
  module Test
    module PageObjectHelpers

      # @return [::ET1::Test::ApplyPage]
      def apply_page
        ::ET1::Test::ApplyPage.new
      end

      # @return [ET1::Test::SavingYourClaimPage] The saving your claim page
      def saving_your_claim_page
        ::ET1::Test::SavingYourClaimPage.new
      end

      # @return [ET1::Test::ReturnToYourClaimPage] The return to your claim page
      def return_to_your_claim_page(&block)
        ET1::Test::ReturnToYourClaimPage.new(&block)
      end

      # @return [ET1::Test::ResetMemorableWordPage] The reset memorable word page
      def reset_memorable_word_page
        ET1::Test::ResetMemorableWordPage.new
      end

      # @return [ET1::Test::ClaimantsDetailsPage]
      def claimants_details_page
        ::ET1::Test::ClaimantsDetailsPage.new
      end

      # @return [ET1::Test::GroupClaimsPage] The group claims page
      def group_claims_page
        ::ET1::Test::GroupClaimsPage.new
      end

      # @return [ET1::Test::GroupClaimsUploadPage] The group claims upload page
      def group_claims_upload_page
        ::ET1::Test::GroupClaimsUploadPage.new
      end

      # The representatives details page
      #
      # @return [ET1::Test::RepresentativesDetailsPage]
      def representatives_details_page
        ::ET1::Test::RepresentativesDetailsPage.new
      end

      # @return [ET1::Test::RespondentsDetailsPage]
      def respondents_details_page
        ::ET1::Test::RespondentsDetailsPage.new
      end

      # @return [ET1::Test::AdditionalRespondentsPage]
      def additional_respondents_page
        ::ET1::Test::AdditionalRespondentsPage.new
      end

      # @return [ET1::Test::EmploymentDetailsPage]
      def employment_details_page
        ::ET1::Test::EmploymentDetailsPage.new
      end

      # @return [ET1::Test::AboutTheClaimPage]
      def about_the_claim_page
        ::ET1::Test::AboutTheClaimPage.new
      end

      # @return [ET1::Test::ClaimDetailsPage]
      def claim_details_page
        ::ET1::Test::ClaimDetailsPage.new
      end

      # @return [ET1::Test::ClaimOutcomePage]
      def claim_outcome_page
        ::ET1::Test::ClaimOutcomePage.new
      end

      # @return [ET1::Test::MoreAboutTheClaimPage]
      def more_about_the_claim_page
        ::ET1::Test::MoreAboutTheClaimPage.new
      end

      # @return [ET1::Test::CheckYourClaimPage]
      def check_your_claim_page
        ::ET1::Test::CheckYourClaimPage.new
      end

      # @return [ET1::Test::ClaimSubmittedPage]
      def claim_submitted_page
        ::ET1::Test::ClaimSubmittedPage.new
      end

      # @return [ET1::Test::NewClaimPage]
      def new_claim_page
        @new_claim_page ||= NewClaimPage.new
      end

      # @return [ET1::Test::StepOnePage]
      def step_one_page
        @step_one_page ||= StepOnePage.new
      end

      # @return [ET1::Test::StepTwoPage]
      def step_two_page
        @step_two_page ||= StepTwoPage.new
      end

      # @return [ET1::Test::StepThreePage]
      def step_three_page
        @step_three_page ||= StepThreePage.new
      end

      # @return [ET1::Test::StepFourPage]
      def step_four_page
        @step_four_page ||= StepFourPage.new
      end

      # @return [ET1::Test::StepFivePage]
      def step_five_page
        @step_five_page ||= StepFivePage.new
      end

      # @return [ET1::Test::StepSixPage]
      def step_six_page
        @step_six_page ||= StepSixPage.new
      end

      # @return [ET1::Test::StepSevenPage]
      def step_seven_page
        @step_seven_page ||= StepSevenPage.new
      end

      # @return [ET1::Test::StepEightPage]
      def step_eight_page
        @step_eight_page ||= StepEightPage.new
      end

      # @return [ET1::Test::StepNinePage]
      def step_nine_page
        @step_nine_page ||= StepNinePage.new
      end

      # @return [ET1::Test::StepTenPage]
      def step_ten_page
        @step_ten_page ||= StepTenPage.new
      end

      # @return [ET1::Test::StepElevenPage]
      def step_eleven_page
        @step_eleven_page ||= StepElevenPage.new
      end

      # @return [ET1::Test::SubmissionPage]
      def submission_page
        @submission_page ||= SubmissionPage.new
      end

      # @return [ET1::Test::ReviewPage]
      def review_page
        @review_page ||= ReviewPage.new
      end

      # @return [ET1::Test::ClaimSubmittedPage]
      def claim_submitted_page
        @claim_submitted_page ||= ClaimSubmittedPage.new
      end

      def refund_step_one_page
        @refund_step_one_page ||= Refunds::StepOnePage.new
      end

      # @return [ET1::Test::Refunds::ApplicantPage]
      def refund_applicant_page
        @refund_applicant_page ||= Refunds::ApplicantPage.new
      end

      # @return [ET1::Test::Refunds::OriginalCaseDetailsPage]
      def refund_original_case_details_page
        @refund_original_case_details_page ||= Refunds::OriginalCaseDetailsPage.new
      end

      # @return [ET1::Test::Refunds::FeesPage]
      def refund_fees_page
        @refund_fees_page ||= Refunds::FeesPage.new
      end

      # @return [ET1::Test::Refunds::PaymentDetailsPage]
      def refund_payment_details_page
        @refund_payment_details_page ||= Refunds::PaymentDetailsPage.new
      end

      # @return [ET1::Test::Refunds::ReviewPage]
      def refund_review_page
        @refund_review_page ||= Refunds::ReviewPage.new
      end

      # @return [ET1::Test::Refunds::ProfileSelectionPage]
      def refund_profile_selection_page
        @refund_profile_selection_page ||= Refunds::ProfileSelectionPage.new
      end

      # @return [ET1::Test::Refunds::ConfirmationPage]
      def refund_confirmation_page
        @refund_confirmation_page ||= Refunds::ConfirmationPage.new
      end

      # @param [String] email_address
      # @return [Et1::Test::EmailObjects::ResetPasswordEmailHtml, Nil] The found email object or nil
      def reset_password_email_for(email_address)
        Et1::Test::EmailObjects::ResetPasswordEmailHtml.find(email_address: email_address)
      end
    end
  end
end

RSpec.configure do |c|
  c.include ::ET1::Test::PageObjectHelpers
end
