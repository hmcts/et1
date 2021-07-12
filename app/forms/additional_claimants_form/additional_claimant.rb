class AdditionalClaimantsForm
  class AdditionalClaimant < CollectionForm::Resource
    TITLES      = ['Mr', 'Mrs', 'Miss', 'Ms'].freeze
    NAME_LENGTH = 100

    include AddressAttributes
    include AgeValidator

    delegate :id, :id=, to: :resource

    attribute :first_name,    :string
    attribute :last_name,     :string
    attribute :date_of_birth, :et_date, allow_2_digit_year: true
    attribute :title,         :string

    booleans   :has_special_needs, :has_representative
    validates  :date_of_birth, date: true

    validates :title, inclusion: { in: TITLES }, ccd_personal_title: true, allow_blank: true
    validates :first_name, :last_name, presence: true
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
    validate :older_then_16

    before_validation :clean_empty_title

    private

    def clean_empty_title
      self.title = nil if title == ''
    end
  end
end
