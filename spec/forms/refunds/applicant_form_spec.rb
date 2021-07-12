require 'rails_helper'
module Refunds
  RSpec.describe ApplicantForm, type: :form do
    let(:session_attributes) { Refund.new.attributes.to_h }
    let(:refund_session) { Session.new session_attributes }
    let(:applicant_form) { described_class.new(refund_session) }

    describe 'validations' do
      context 'applicant_address_building' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_address_building)
        end

        it 'validates length' do
          expect(applicant_form).to validate_length_of(:applicant_address_building).is_at_most(50)
        end
      end

      context 'applicant_address_street' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_address_street)
        end

        it 'validates length' do
          expect(applicant_form).to validate_length_of(:applicant_address_street).is_at_most(50)
        end
      end

      context 'applicant_address_locality' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_address_locality)
        end

        it 'validates the length' do
          expect(applicant_form).to validate_length_of(:applicant_address_locality).is_at_most(25)
        end
      end

      context 'applicant_address_county' do
        it 'validates the length' do
          expect(applicant_form).to validate_length_of(:applicant_address_county).is_at_most(25)
        end
      end

      context 'applicant_address_post_code' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_address_post_code)
        end

        it 'validates length' do
          expect(applicant_form).to validate_length_of(:applicant_address_post_code).is_at_most(8)
        end
      end

      context 'applicant_address_telephone_number' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_address_telephone_number)
        end

        it 'validates length' do
          expect(applicant_form).to validate_length_of(:applicant_address_telephone_number).is_at_most(21)
        end
      end

      context 'applicant_title' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_title)
        end

        it 'validates inclusion' do
          expect(applicant_form).to validate_inclusion_of(:applicant_title).in_array(['mr', 'mrs', 'miss', 'ms'])
        end
      end

      context 'applicant_first_name' do
        it 'validates length' do
          expect(applicant_form).to validate_length_of(:applicant_first_name).is_at_most(100)
        end
      end

      context 'applicant_last_name' do
        it 'validates length' do
          expect(applicant_form).to validate_length_of(:applicant_last_name).is_at_most(100)
        end
      end

      context 'applicant_email_address' do
        it 'allows blank' do
          applicant_form.applicant_email_address = ''
          applicant_form.valid?
          expect(applicant_form.errors).not_to include :applicant_email_address
        end

        it 'validates email - allowing a good email address' do
          applicant_form.applicant_email_address = 'test@test.com'
          applicant_form.valid?
          expect(applicant_form.errors).not_to include :applicant_email_address
        end

        it 'validates email - disallowing a bad email address' do
          applicant_form.applicant_email_address = 'test.com'
          applicant_form.valid?
          expect(applicant_form.errors).to include :applicant_email_address
        end

        it 'validates length' do
          expect(applicant_form).to validate_length_of(:applicant_email_address).is_at_most(100)
        end
      end

      context 'applicant_date_of_birth' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_date_of_birth)
        end

        it 'validate date - allowing a good value' do
          value = { 'applicant_date_of_birth(3i)' => '15',
                    'applicant_date_of_birth(2i)' => '11',
                    'applicant_date_of_birth(1i)' => '1985' }
          applicant_form.assign_attributes(value)

          applicant_form.applicant_date_of_birth = { 3 => '1', 2 => '3', 1 => '1980' }
          applicant_form.valid?
          expect(applicant_form.errors).not_to include :applicant_date_of_birth
        end

        it 'validate date - disallowing an 2 digit year' do
          value = { 'applicant_date_of_birth(3i)' => '1',
                    'applicant_date_of_birth(2i)' => '1',
                    'applicant_date_of_birth(1i)' => '80' }
          applicant_form.assign_attributes(value)
          applicant_form.valid?
          expect(applicant_form.errors).to include :applicant_date_of_birth
        end

        it 'validate date - disallowing an invalid date' do
          value = { 'applicant_date_of_birth(3i)' => '32',
                    'applicant_date_of_birth(2i)' => '15',
                    'applicant_date_of_birth(1i)' => '1980' }
          applicant_form.assign_attributes(value)

          applicant_form.valid?
          expect(applicant_form.errors).to include :applicant_date_of_birth
        end

        it 'validates date - disallowing a blank value' do
          value = { 'applicant_date_of_birth(3i)' => '',
                    'applicant_date_of_birth(2i)' => '',
                    'applicant_date_of_birth(1i)' => '' }
          applicant_form.assign_attributes(value)

          applicant_form.valid?
          expect(applicant_form.errors).to include :applicant_date_of_birth
        end

        it 'validates date - disallowing a nil value' do
          applicant_form.applicant_date_of_birth = nil
          applicant_form.valid?
          expect(applicant_form.errors).to include :applicant_date_of_birth
        end
      end

      context 'has_name_changed' do
        it 'validates - disallowing nil value' do
          applicant_form.has_name_changed = nil
          applicant_form.valid?
          expect(applicant_form.errors).to include :has_name_changed
        end

        it 'validates - disallowing empty string value' do
          applicant_form.has_name_changed = ''
          applicant_form.valid?
          expect(applicant_form.errors).to include :has_name_changed
        end

        it 'validates - allowing true' do
          applicant_form.has_name_changed = 'true'
          applicant_form.valid?
          expect(applicant_form.errors).not_to include :has_name_changed
        end

        it 'validates - allowing false' do
          applicant_form.has_name_changed = 'false'
          applicant_form.valid?
          expect(applicant_form.errors).not_to include :has_name_changed
        end
      end

    end

    describe '#applicant_first_name=' do
      it 'strips the string' do
        applicant_form.applicant_first_name = ' test '
        expect(applicant_form.applicant_first_name).to eql 'test'
      end
    end

    describe '#applicant_last_name=' do
      it 'strips the string' do
        applicant_form.applicant_last_name = ' test '
        expect(applicant_form.applicant_last_name).to eql 'test'
      end
    end

    describe '#applicant_date_of_birth=' do
      # I don't understand this craziness, but this is how it works currently
      # @TODO See if the functionality provided by the 'dates' class method can be done better
      #
      it 'converts to the correct date if a hash with string keys is given' do
        value = { 3 => '15', 2 => '11', 1 => '1985' }
        applicant_form.applicant_date_of_birth = value
        expect(applicant_form.applicant_date_of_birth).to eql Date.parse('15/11/1985')
      end

      it 'converts to the correct date if an ActionController:Parameters is given with string keys' do
        value = ActionController::Parameters.new 'applicant_date_of_birth(3i)' => '15',
                                                 'applicant_date_of_birth(2i)' => '11',
                                                 'applicant_date_of_birth(1i)' => '1985'
        applicant_form.assign_attributes(value.permit(:applicant_date_of_birth))
        expect(applicant_form.applicant_date_of_birth).to eql Date.parse('15/11/1985')
      end


      it 'stores the provided hash if the date is invalid' do
        value = { 3 => '32', 2 => '15', 1 => '1985' }
        applicant_form.applicant_date_of_birth = value
        expect(applicant_form.applicant_date_of_birth_before_type_cast).to be value
      end

      it 'stores the provided ActionController::Parameters as a hash if the date is invalid' do
        value = ActionController::Parameters.new(3 => '32', 2 => '15', 1 => '1985').freeze
        applicant_form.applicant_date_of_birth = value
        expect(applicant_form.applicant_date_of_birth).to eql(3 => '32', 2 => '15', 1 => '1985')
      end
    end

    describe 'standard form behavior' do
      attrs = {
        applicant_address_building: '1',
        applicant_address_street: 'Street',
        applicant_address_locality: 'Locality',
        applicant_address_post_code: 'DE21 6QQ',
        applicant_title: 'mr',
        applicant_first_name: 'First',
        applicant_last_name: 'Last',
        applicant_address_telephone_number: '01332 222222',
        applicant_date_of_birth: 18.years.ago,
        has_name_changed: false
      }
      it_behaves_like 'a Form', attrs, Session
    end
  end
end
