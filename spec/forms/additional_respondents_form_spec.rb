require 'rails_helper'

RSpec.describe AdditionalRespondentsForm, type: :form do
  subject(:additional_respondents_form) { described_class.new(claim) }

  let(:attributes) do
    {
      has_multiple_respondents: 'true',
      secondary_respondents_attributes: {
        "0" => {
          name: 'Butch McTaggert',
          acas_early_conciliation_certificate_number: 'XX123456/12/12',
          address_building: '1', address_street: 'High Street',
          address_locality: 'Anytown', address_county: 'Anyfordshire',
          address_post_code: 'W2 3ED'
        },
        "1" => {
          name: 'Pablo Noncer',
          acas_early_conciliation_certificate_number: 'XX123456/12/12',
          address_building: '2', address_street: 'Main Street',
          address_locality: 'Anycity', address_county: 'Anyford',
          address_post_code: 'W2 3ED'
        }
      }
    }
  end

  let(:claim) { create(:claim, :with_secondary_respondents) }

  describe '#secondary_respondents_attributes=' do
    before do
      additional_respondents_form.attributes = attributes
    end

    it 'builds new respondents with attributes' do
      additional_respondents_form.secondary_respondents.slice(2,2).each_with_index do |c, i|
        attributes[:secondary_respondents_attributes].values[i].each do |key, value|
          expect(c.send(key)).to eq value
        end
      end
    end

    it 'new additional respondents are decorated as Respondents' do
      additional_respondents_form.secondary_respondents.each_with_index do |_c, i|
        expect(additional_respondents_form.secondary_respondents).to all(be_an_instance_of(AdditionalRespondentsForm::RespondentForm))
      end
    end
  end

  describe '#secondary_respondents' do
    describe 'decorates any secondary respondents in a RespondentForm' do
      before do
        additional_respondents_form.attributes = attributes
      end

      it { expect(additional_respondents_form.secondary_respondents.length).to be 4 }
      it { expect(additional_respondents_form.secondary_respondents).to all(be_an_instance_of(AdditionalRespondentsForm::RespondentForm)) }
    end
  end

  describe '#has_multiple_respondents=' do
    it 'empties the collection when set to false' do
      subject.has_multiple_respondents = false
      subject.save
      expect(claim.reload.secondary_respondents.count).to be_zero
    end
  end

  describe '#save' do
    context 'when there are no secondary respondents' do
      let(:claim) { create(:claim, :with_secondary_respondents) }

      it 'creates the secondary respondents' do
        additional_respondents_form.attributes = attributes
        additional_respondents_form.save
        claim.secondary_respondents.reload

        attributes[:secondary_respondents_attributes].each do |str_index, attributes|
          attributes.each do |k, v|
            expect(claim.secondary_respondents.slice(2,2)[str_index.to_i].send(k)).to eq v
          end
        end
      end
    end

    context 'when there are existing secondary respondents' do
      before do
        additional_respondents_form.assign_attributes attributes
        additional_respondents_form.save
        claim.secondary_respondents.reload
      end

      it 'has 4 secondary respondents' do
        expect(claim.secondary_respondents.count).to be(4)
      end

      it 'updates the secondary respondents attributes' do
        attributes[:secondary_respondents_attributes].each_with_index do |(_, attributes), index|
          attributes.each { |k, v| expect(claim.secondary_respondents.slice(2,2)[index].send(k)).to eq v }
        end
      end
    end

    context 'when all #respondents are valid' do
      before do
        additional_respondents_form.attributes = attributes
      end

      it 'returns true' do
        expect(additional_respondents_form.save).to be true
      end
    end

    context 'when some respondents are not valid' do
      let(:attributes) do
        {
          has_multiple_respondents: 'true',
          secondary_respondents_attributes: {
            "0" => {
              name: 'Butch McTaggert',
              no_acas_number: 'false',
              acas_early_conciliation_certificate_number: 'invalid',
              address_building: '1', address_street: 'High Street',
              address_locality: 'Anytown', address_county: 'Anyfordshire',
              address_post_code: 'W2 3ED'
            },
            "1" => {
              name: 'Pablo Noncer',
              no_acas_number: 'false',
              acas_early_conciliation_certificate_number: 'XX123456/12/12',
              address_building: '2', address_street: 'Main Street',
              address_locality: 'Anycity', address_county: 'Anyford',
              address_post_code: 'W2 3ED'
            }
          }
        }
      end
      before do
        additional_respondents_form.attributes = attributes
      end
      it 'returns false' do
        expect(additional_respondents_form.save).to be false
      end
    end
  end
end
