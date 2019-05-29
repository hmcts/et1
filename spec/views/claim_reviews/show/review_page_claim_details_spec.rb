require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "claim_details" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end

    let(:null_object) { NullObject.new }
    before do
      render template: "claim_reviews/show", locals: {
        claim: claim,
        primary_claimant: claim.primary_claimant || null_object,
        representative: claim.representative || null_object,
        employment: claim.employment || null_object,
        respondent: claim.primary_respondent || null_object,
        secondary_claimants: claim.secondary_claimants,
        secondary_respondents: claim.secondary_respondents
      }
      review_page.load(rendered)
    end

    let(:claim) do
      create :claim, claim_details: "wut\r\nwut", other_known_claimant_names: "Johnny Wishbone\r\nSamuel Pepys"
    end

    context 'Claim details' do
      subject { review_page.claim_details.claim_details.answer.native.inner_html }
      it { is_expected.to eq("wut\n<br>wut") }
    end

    context 'Other known claimant names' do
      subject { review_page.claim_details.other_known_claimants.answer.native.inner_html }
      it { is_expected.to eq("Johnny Wishbone\n<br>Samuel Pepys") }
    end

    context 'Attached documents' do
      subject { review_page.claim_details.attached_documents.answer.native.inner_html }
      it { is_expected.to eq('big.rtf') }
    end
  end
end
