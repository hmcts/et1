class AdditionalClaimantsForm < Form
  include ValidateNested
  attribute :has_multiple_claimants, :boolean
  attribute :secondary_claimants
  validate :validate_associated_records_for_secondary_claimants
  before_validation :remove_secondaries, unless: :has_multiple_claimants
  has_many_forms :secondary_claimants, class_name: '::AdditionalClaimantsForm::ClaimantForm'

  def persisted_attributes
    attributes.except('secondary_claimants')
  end

  def save
    if valid?
      run_callbacks :save do
        ActiveRecord::Base.transaction do
          target.update persisted_attributes unless target.frozen?
          resource.save
        end
      end
    else
      false
    end
  end

  private

  attr_accessor :_resource

  def validate_associated_records_for_secondary_claimants
    validate_collection_association(:secondary_claimants)
  end

  def remove_secondaries
    secondary_claimants.clear
  end

  class ClaimantForm < Form
    TITLES      = ['Mr', 'Mrs', 'Miss', 'Ms'].freeze
    NAME_LENGTH = 100

    include AddressAttributes
    include AgeValidator

    attribute :id
    attribute :first_name,    :string
    attribute :last_name,     :string
    attribute :date_of_birth, :et_date
    attribute :title,         :string
    attribute :has_special_needs, :boolean
    attribute :has_representative, :boolean

    validates  :date_of_birth, date: true

    validates :title, inclusion: { in: TITLES }, allow_blank: true
    validates :first_name, :last_name, presence: true
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
    validate :older_then_16

    def persisted_attributes
      attributes.except('has_special_needs', 'has_representative', 'id')
    end
  end
end
