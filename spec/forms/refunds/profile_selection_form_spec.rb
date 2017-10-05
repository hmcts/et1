require 'rails_helper'
module Refunds
  RSpec.describe ProfileSelectionForm, type: :form do
    let(:refund) { instance_spy(Refund) }
    let(:form) { described_class.new(refund) }

    it_behaves_like 'a Form', { profile_type: 'claimant_direct_not_reimbursed' }, Refund

    describe 'validations' do
      context 'profile_type' do
        it 'validates presence of' do
          expect(form).to validate_presence_of(:profile_type)
        end

        it 'validates inclusion' do
          expect(form).to validate_inclusion_of(:profile_type).
            in_array(['claimant_direct_not_reimbursed', 'claimant_via_rep', 'claimant_eat']).
            allow_blank(false)
        end
      end
    end

  end
end