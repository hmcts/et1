require 'rails_helper'
module Refunds
  RSpec.describe ApplicantForm, type: :form do
    let(:refund) { instance_spy(Refund) }
    let(:applicant_form) { described_class.new(refund) }

    describe 'validations' do
      context 'applicant_address_building' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_address_building)
        end

        it 'validates length' do
          expect(applicant_form).to ensure_length_of(:applicant_address_building).is_at_most(75)
        end
      end

      context 'applicant_address_street' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_address_street)
        end

        it 'validates length' do
          expect(applicant_form).to ensure_length_of(:applicant_address_street).is_at_most(75)
        end
      end

      context 'applicant_address_locality' do
        it 'validates the length' do
          expect(applicant_form).to ensure_length_of(:applicant_address_locality).is_at_most(25)
        end
      end

      context 'applicant_address_county' do
        it 'validates the length' do
          expect(applicant_form).to ensure_length_of(:applicant_address_county).is_at_most(25)
        end
      end

      context 'applicant_address_post_code' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_address_post_code)
        end

        it 'validates length' do
          expect(applicant_form).to ensure_length_of(:applicant_address_post_code).is_at_most(8)
        end
      end

      context 'applicant_address_telephone_number' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_address_telephone_number)
        end

        it 'validates length' do
          expect(applicant_form).to ensure_length_of(:applicant_address_telephone_number).is_at_most(21)
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
          expect(applicant_form).to ensure_length_of(:applicant_first_name).is_at_most(100)
        end
      end

      context 'applicant_last_name' do
        it 'validates length' do
          expect(applicant_form).to ensure_length_of(:applicant_last_name).is_at_most(100)
        end
      end

      context 'email_address' do
        it 'allows blank' do
          applicant_form.email_address = ''
          applicant_form.valid?
          expect(applicant_form.errors).not_to include :email_address
        end

        it 'validates email - allowing a good email address' do
          applicant_form.email_address = 'test@test.com'
          applicant_form.valid?
          expect(applicant_form.errors).not_to include :email_address
        end

        it 'validates email - disallowing a bad email address' do
          applicant_form.email_address = 'test.com'
          applicant_form.valid?
          expect(applicant_form.errors).to include :email_address
        end

        it 'validates length' do
          expect(applicant_form).to ensure_length_of(:email_address).is_at_most(100)
        end
      end

      context 'applicant_date_of_birth' do
        it 'validates presence' do
          expect(applicant_form).to validate_presence_of(:applicant_date_of_birth)
        end

        it 'validate date - allowing a good value' do
          applicant_form.applicant_date_of_birth = { day: '1', month: '3', year: '1980' }
          applicant_form.valid?
          expect(applicant_form.errors).not_to include :applicant_date_of_birth
        end

        it 'validate date - disallowing an invalid date' do
          applicant_form.applicant_date_of_birth = { day: '32', month: '15', year: '1980' }
          applicant_form.valid?
          expect(applicant_form.errors).to include :applicant_date_of_birth
        end

        it 'validates date - disallowing a blank value' do
          applicant_form.applicant_date_of_birth = { day: '', month: '', year: '' }
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
        value = { 'day' => '15', 'month' => '11', "year" => '1985' }
        applicant_form.applicant_date_of_birth = value
        expect(applicant_form.applicant_date_of_birth).to eql Date.parse('15/11/1985')
      end

      it 'converts to the correct date if an ActionController:Parameters is given with string keys' do
        value = ActionController::Parameters.new('day' => '15', 'month' => '11', "year" => '1985')
        applicant_form.applicant_date_of_birth = value
        expect(applicant_form.applicant_date_of_birth).to eql Date.parse('15/11/1985')
      end

      it 'stores nil if the values of the hash are all not present' do
        value = { 'day' => '', 'month' => '', "year" => '' }
        applicant_form.applicant_date_of_birth = value
        expect(applicant_form.applicant_date_of_birth).to be_nil
      end

      it 'stores nil if the values of the ActionController::Parameters are all not present' do
        value = ActionController::Parameters.new('day' => '', 'month' => '', "year" => '')
        applicant_form.applicant_date_of_birth = value
        expect(applicant_form.applicant_date_of_birth).to be_nil
      end

      it 'stores the provided hash if the date is invalid' do
        value = { 'day' => '32', 'month' => '15', "year" => '1985' }
        applicant_form.applicant_date_of_birth = value
        expect(applicant_form.applicant_date_of_birth).to be value
      end

      it 'stores the provided ActionController::Parameters if the date is invalid' do
        value = ActionController::Parameters.new('day' => '32', 'month' => '15', "year" => '1985')
        applicant_form.applicant_date_of_birth = value
        expect(applicant_form.applicant_date_of_birth).to be value
      end
    end
  end
end