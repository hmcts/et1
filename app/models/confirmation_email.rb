class ConfirmationEmail
  include ActiveModel::Model
  delegate :primary_claimant, :representative, :secondary_claimants, to: :claim
  attr_accessor :email_addresses, :additional_email_address

  def initialize(claim)
    @claim = claim
    @email_addresses = []
    if primary_claimant_ticked?
      @email_addresses << primary_claimant.email_address
    end
    if representative_ticked?
      @email_addresses << representative.email_address
    end
  end

  def all_email_addresses
    [primary_claimant.email_address, representative&.email_address].compact.map { |email| [email] }
  end

  private

  attr_reader :claim

  def primary_claimant_ticked?
    secondary_claimants.none? || representative.try(:email_address).blank?
  end

  def representative_ticked?
    representative.present? && representative.email_address.present?
  end
end
