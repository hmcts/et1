class ClaimDetailsForm < Form
  attribute :claim_details,               :string
  attribute :other_known_claimant_names,  :string
  attribute :claim_details_rtf,           :attachment_uploader_type
  attribute :uploaded_file_key,           :string
  attribute :uploaded_file_name,          :string

  boolean :other_known_claimants

  delegate :claim_details_rtf_cache, :claim_details_rtf_cache=, to: :target

  validates :claim_details, length: { maximum: 2500 },
                            presence: true,
                            unless: -> { uploaded_file_key.present? }
  validates :other_known_claimant_names, length: { maximum: 350 }
  validates :claim_details_rtf, content_type: {
    in: ['text/rtf'], message: I18n.t('errors.messages.rtf')
  }

  def claim_form_details_rtf?
    resource.claim_details_rtf_file.present?
  end

  def attachment_filename
    CarrierwaveFilename.for claim_details_rtf
  end

  def other_known_claimants
    @other_known_claimants ||= other_known_claimant_names?
  end
end
