require 'rails_helper'

describe ConfirmationEmail do
  let(:claim) { create(:claim) }
  let(:confirmation_email) { described_class.new(claim) }

  describe '#initialize' do
    it 'has the correct values for the email_addresses' do
      expect(confirmation_email.email_addresses).to contain_exactly(claim.primary_claimant.email_address)
    end
  end

  describe '#all_email_addresses' do
    it 'has the correct values' do
      expect(confirmation_email.all_email_addresses).to contain_exactly([claim.primary_claimant.email_address])
    end
  end
end
