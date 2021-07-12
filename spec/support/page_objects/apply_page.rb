require_relative './base_page'
module ET1
  module Test
    class ApplyPage < BasePage
      set_url "/apply"

      # Starts a new claim by clicking on 'Start a claim'
      def start_a_claim
        start_a_claim_element.click
        ::ET1::Test::SavingYourClaimPage.new
      end

      # Return to an existing claim by clicking on 'Return to a claim'
      def return_to_a_claim
        return_to_a_claim_element.click
        ET1::Test::ReturnToYourClaimPage.new
      end

      private

      element :start_a_claim_element, :link_or_button_translated, 'apply.start_a_claim'
      element :return_to_a_claim_element, :link_or_button_translated, 'apply.return_to_a_claim'
    end
  end
end
