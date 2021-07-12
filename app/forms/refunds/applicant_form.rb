module Refunds
  class ApplicantForm < Form
    TITLES               = ['mr', 'mrs', 'miss', 'ms'].freeze
    GENDERS              = ['male', 'female', 'prefer_not_to_say'].freeze
    CONTACT_PREFERENCES  = ['email', 'post'].freeze
    EMAIL_ADDRESS_LENGTH = 100
    NAME_LENGTH          = 100

    attribute :applicant_address_building,         :string
    attribute :applicant_address_street,           :string
    attribute :applicant_address_locality,         :string
    attribute :applicant_address_county,           :string
    attribute :applicant_address_post_code,        :string
    attribute :applicant_address_telephone_number, :string
    attribute :has_name_changed, :boolean

    validates :applicant_address_building, :applicant_address_street,
      :applicant_address_post_code, :applicant_address_locality, presence: true

    validates :applicant_address_building,
      :applicant_address_street,
      length: { maximum: AddressAttributes::ADDRESS_LINE_LENGTH }
    validates :applicant_address_locality,
      :applicant_address_county,
      length: { maximum: AddressAttributes::LOCALITY_LENGTH }
    validates :applicant_address_telephone_number,
      length: { maximum: AddressAttributes::PHONE_NUMBER_LENGTH }

    validates :applicant_address_post_code,
      length: { maximum: AddressAttributes::POSTCODE_LENGTH }
    attribute :applicant_first_name,         :string
    attribute :applicant_last_name,          :string
    attribute :applicant_date_of_birth,      :et_date
    attribute :applicant_email_address, :string
    attribute :applicant_title, :string

    validates :applicant_title, :applicant_first_name, :applicant_last_name, presence: true

    validates :applicant_title, inclusion: { in: TITLES }
    validates :applicant_first_name, :applicant_last_name, length: { maximum: NAME_LENGTH }
    validates :applicant_email_address, allow_blank: true,
                                        email: true,
                                        length: { maximum: EMAIL_ADDRESS_LENGTH }
    validates :applicant_address_telephone_number, presence: true
    validates :applicant_date_of_birth, presence: true
    validates :has_name_changed, nil_or_empty: true

    validates :applicant_date_of_birth, date: true

    def applicant_first_name=(name)
      write_attribute :applicant_first_name, name.try(:strip)
    end

    def applicant_last_name=(name)
      write_attribute :applicant_last_name,  name.try(:strip)
    end
  end
end
