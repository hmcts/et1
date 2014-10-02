require 'rails_helper'

describe Representative do
  it { is_expected.to have_one :address }
  it { is_expected.to belong_to :claim }

  it_behaves_like "it has an address", :address

  describe '#address' do
    describe 'when the association is empty' do
      it 'prepopulates the association with a bare address' do
        expect(subject.address).to be_an Address
      end
    end
  end
end
