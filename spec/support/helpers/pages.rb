module ET1
  module Test
    module Pages
      def base_page
        ET1::Test::BasePage.new
      end

      def claim_details_page
        ET1::Test::ClaimDetailsPage.new
      end
    end
  end
end
