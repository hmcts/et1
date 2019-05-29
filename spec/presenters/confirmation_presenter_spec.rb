require 'rails_helper'

RSpec.describe ConfirmationPresenter, type: :presenter do
  let(:confirmation_presenter) { described_class.new claim }

  let(:claim) { create :claim }

  around do |example|
    travel_to(Time.new(2014).utc) { example.run }
  end

  describe 'submission_information' do
    context 'when there is an associated fee office' do
      before { claim.build_office name: 'Brum', address: 'Brum lane, B1 1AA' }

      context 'and no claimants seeking remission' do
        it 'has the submitted date, the name, and address of the fee centre' do
          expect(confirmation_presenter.submission_information).
            to eq 'Submitted 01 January 2014 to tribunal office Brum, Brum lane, B1 1AA'
        end

        context 'Welsh locale' do
          before { I18n.locale = :cy }

          it 'has the submitted date, the name, and address of the fee centre' do
            expect(confirmation_presenter.submission_information).
              to eq 'Cyflwynwyd ar 01 Ionawr 2014 i swyddfa tribiwnlys Brum, Brum lane, B1 1AA'
          end

          context 'Welsh address' do
            before do
              claim.build_office name: 'Wales', address: 'Employment Tribunal, Cardiff, CF24 0RZ'
            end

            it 'has the submitted date, the name, and address of the fee centre' do
              expect(confirmation_presenter.submission_information).
                to eq 'Cyflwynwyd ar 01 Ionawr 2014 i swyddfa tribiwnlys Cymru, Tribiwnlys Cyflogaeth, 3ydd Llawr, Llys Ynadon Caerdydd a’r Fro, Plas Fitzalan, Caerdydd, CF24 0RA'
            end
          end
        end

      end


      context 'and claimants are seeking remission' do
        before { claim.remission_claimant_count = 1 }

        it 'is the submission date' do
          expect(confirmation_presenter.submission_information).
            to eq 'Submitted 01 January 2014'
        end
      end
    end

    context 'when there is no associated fee office' do
      let(:claim) { create :claim, :no_fee_group_reference }

      it 'is the submission date' do
        expect(confirmation_presenter.submission_information).
          to eq 'Submitted 01 January 2014'
      end
    end
  end

  it { expect(confirmation_presenter.attachments).to eq 'big.rtf<br />file.csv' }

  describe '#each_item' do
    it 'yields the submission information' do
      expect { |b| confirmation_presenter.each_item(&b) }.
        to yield_successive_args [:submission_information, "Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU"],
          [:attachments, "big.rtf<br />file.csv"]
    end

    context 'when no attachments were uploaded' do
      let(:claim) { create :claim, :no_attachments }

      it 'yields text to state no attachments are present' do
        expect { |b| confirmation_presenter.each_item(&b) }.
          to yield_successive_args [:submission_information, "Submitted 01 January 2014 to tribunal office Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU"],
            [:attachments, "None"]
      end
    end
  end
end
