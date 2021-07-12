require 'rails_helper'

RSpec.describe AdditionalClaimantsForm, type: :form do
  subject(:additional_claimants_form) { described_class.new(claim) }

  let(:attributes) do
    {
      has_multiple_claimants: 'true',
      secondary_claimants_attributes: {
        "0" => {
          title: 'Mr', first_name: 'Barrington', last_name: 'Wrigglesworth',
          address_building: '1', address_street: 'High Street',
          address_locality: 'Anytown', address_county: 'Anyfordshire',
          address_post_code: 'W2 3ED', date_of_birth: Date.civil(1995, 1, 1)
        },
        "1" => {
          title: 'Mrs', first_name: 'Lollington', last_name: 'Wrigglesworth',
          address_building: '2', address_street: 'Main Street',
          address_locality: 'Anycity', address_county: 'Anyford',
          address_post_code: 'W2 3ED', date_of_birth: Date.civil(1995, 1, 1)
        }
      }
    }
  end

  let(:claim) { create(:claim, :with_secondary_claimants) }

  describe '#secondary_claimants_attributes=' do
    it 'builds new claimants with attributes, adding to the existing 2' do
      additional_claimants_form.attributes = attributes
      additional_claimants_form.secondary_claimants.slice(2,2).each_with_index do |c, i|
        attributes[:secondary_claimants_attributes].values[i].each do |key, value|
          expect(c.send(key)).to eq value
        end
      end
    end

    it 'deletes the existing 2 if specified whilst adding the new' do
      claim.secondary_claimants.each_with_index do | claimant, index|
        attributes[:secondary_claimants_attributes][(index +2).to_s] = { id: claimant.id, _destroy: '1' }
      end

      additional_claimants_form.attributes = attributes
      additional_claimants_form.save
      additional_claimants_form.secondary_claimants.each_with_index do |c, i|
        attributes[:secondary_claimants_attributes].values[i].each do |key, value|
          expect(c.send(key)).to eq value
        end
      end
    end

    it 'decorates AdditionalClaimants as Claimants' do
      additional_claimants_form.attributes = attributes
      expect(additional_claimants_form.secondary_claimants).to all(be_an_instance_of(AdditionalClaimantsForm::ClaimantForm))
    end
  end

  describe '#claimants' do
    let(:form)     { additional_claimants_form.secondary_claimants.last }

    describe 'decorates any secondary claimants in an AdditionalClaimants' do
      it { expect(additional_claimants_form.secondary_claimants.length).to be 2 }
      it { expect(form).to be_a AdditionalClaimantsForm::ClaimantForm }
    end
  end

  describe '#has_multiple_claimants=' do
    it 'empties the collection when set to false' do
      subject.has_multiple_claimants = false
      subject.save
      expect(claim.reload.secondary_claimants.count).to be_zero
    end
  end

  describe '#save' do
    context 'when there are no secondary claimants' do
      it 'creates the secondary claimants' do
        additional_claimants_form.attributes = attributes
        additional_claimants_form.save
        claim.secondary_claimants.reload

        attributes[:secondary_claimants_attributes].sort.each_with_index do |(_, attributes), index|
          attributes.each { |k, v| expect(claim.secondary_claimants.slice(2, 2)[index].send(k)).to eq v }
        end
      end
    end

    context 'when there are existing secondary claimants' do
      before do
        additional_claimants_form.attributes = attributes
        additional_claimants_form.save
        claim.secondary_claimants.reload
      end

      it 'has 4 secondary claimants' do
        expect(claim.secondary_claimants.count).to be(4)
      end

      it 'updates the secondary claimants attributes' do
        attributes[:secondary_claimants_attributes].sort.each_with_index do |(_, attributes), index|
          attributes.each { |k, v| expect(claim.secondary_claimants.slice(2,2)[index].send(k)).to eq v }
        end
      end
    end

    context 'when all #claimants are valid' do
      before do
        additional_claimants_form.assign_attributes attributes
      end

      it 'returns true' do
        expect(additional_claimants_form.save).to be true
      end
    end

    context 'when some #claimants are not valid' do
      let(:attributes) do
        {
          has_multiple_claimants: 'true',
          secondary_claimants_attributes: {
            "0" => {
              title: 'invalid', first_name: '', last_name: '',
              address_building: '1', address_street: 'High Street',
              address_locality: 'Anytown', address_county: 'Anyfordshire',
              address_post_code: 'W2 3ED', date_of_birth: Date.civil(1995, 1, 1)
            }
          }
        }
      end
      before { additional_claimants_form.attributes = attributes }

      it 'returns false' do
        expect(additional_claimants_form.save).to be false
      end
    end

    context 'valid?' do
      let(:attributes) do
        {
          has_multiple_claimants: 'false'
        }
      end
      before { additional_claimants_form.attributes = attributes }

      it 'returns true' do
        expect(additional_claimants_form.valid?).to be true
      end
    end
  end
end
