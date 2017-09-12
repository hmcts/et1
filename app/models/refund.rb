class Refund < ActiveRecord::Base
  include Reference
  has_secure_password validations: false
  after_initialize :generate_application_reference
  alias_attribute :address_building, :applicant_address_building
  alias_attribute :address_street, :applicant_address_street
  alias_attribute :address_locality, :applicant_address_locality
  alias_attribute :address_county, :applicant_address_county
  alias_attribute :address_post_code, :applicant_address_post_code
  alias_attribute :address_telephone_number, :applicant_address_telephone_number
  alias_attribute :address_country, :applicant_address_country
  alias_attribute :title, :applicant_title
  alias_attribute :first_name, :applicant_first_name
  alias_attribute :last_name, :applicant_last_name
  alias_attribute :date_of_birth, :applicant_date_of_birth
end