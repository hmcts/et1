require 'rails_helper'

RSpec.describe Claim, type: :claim do
  it { is_expected.to have_secure_password }

  it { is_expected.to have_one(:application_reference) }

  it { is_expected.to have_many(:claimants).dependent(:destroy) }
  it { is_expected.to have_many(:secondary_claimants).conditions primary_claimant: false }

  it { is_expected.to have_many(:respondents).dependent(:destroy) }
  it { is_expected.to have_many(:secondary_respondents).conditions primary_respondent: false }

  it { is_expected.to have_one(:representative).dependent(:destroy) }
  it { is_expected.to have_one(:employment).dependent(:destroy) }
  it { is_expected.to have_one(:office).dependent(:destroy) }
  it { is_expected.to have_one(:primary_claimant).conditions primary_claimant: true }
  it { is_expected.to have_one(:primary_respondent).conditions primary_respondent: true }
  it { is_expected.to have_one(:payment) }

  subject { described_class.create }

  before do
    allow(ClaimSubmissionJob).to receive :perform_later
  end

  include_context 'block pdf generation'
  let(:pdf) { Tempfile.new 'such' }

  describe 'callbacks' do
    let(:claim) { create :claim }

    describe 'after_create' do
      it 'creates a "created" event' do
        expect(subject.events.first[:event]).to eq 'created'
      end
    end

    describe 'after_update' do
      context 'when additional_claimants_csv changed' do
        before do
          allow(claim).
            to receive(:additional_claimants_csv_changed?).and_return(true)
        end

        it 'destroys all secondary_claimants' do
          expect(claim.secondary_claimants).to receive(:destroy_all)
          claim.save
        end
      end

      context 'when additional_claimants_csv did not change' do
        before do
          allow(claim).
            to receive(:additional_claimants_csv_changed?).and_return(false)
        end

        it 'does not destroy secondary_claimants' do
          expect(claim.secondary_claimants).to_not receive(:destroy_all)
          claim.save
        end
      end
    end

    describe 'after_update when adding secondary_claimants' do
      it 'deletes additional_claimants_csv and resets additional claimants counter' do
        claim.secondary_claimants.build

        claim.save

        expect(claim.additional_claimants_csv_record_count).to be_zero
        expect(claim.additional_claimants_csv.url).to be_blank
      end
    end
  end

  %i<created_at amount reference>.each do |meth|
    describe "#payment_#{meth}" do
      context 'when #payment is nil' do
        it 'returns nil' do
          expect(subject.send "payment_#{meth}").to be nil
        end
      end

      context 'when #payment is not nil' do
        let(:payment) { double :payment }
        before { allow(subject).to receive(:payment).and_return payment }

        it 'delegates to #payment' do
          expect(payment).to receive(meth).and_return 'lol'
          expect(subject.send "payment_#{meth}").to eq 'lol'
        end
      end
    end
  end

  describe '#reference' do
    it 'delegates to its ApplicationReferences reference' do
      expect(subject.application_reference).to receive(:reference)
      subject.reference
    end
  end

  describe '.find_by_reference' do
    it 'returns the claim with the corresponding reference' do
      allow(ApplicationReference).to receive(:generate).and_return('ABCD-1234')
      claim = described_class.create!
      expect(described_class.find_by_reference('ABCD-1234')).to eql(claim)
    end

    it 'normalises the reference before looking up' do
      allow(ApplicationReference).to receive(:generate).and_return('ABCD-1234')
      claim = described_class.create!
      expect(described_class.find_by_reference('abcd-l234')).to eql(claim)
    end

    context "no record is found" do
      it "returns nil" do
        described_class.destroy_all
        expect(described_class.find_by_reference('ABCD-1234')).to be_nil
      end
    end
  end

  describe '#claimant_count' do
    it 'delegates to the claimant association proxy' do
      expect(subject.claimants).to receive(:count).and_return(0)

      subject.claimant_count
    end

    it 'adds the cached additonal claimants csv count' do
      subject.additional_claimants_csv_record_count = 1

      expect(subject.claimants).to receive(:count).and_return(0)
      expect(subject.claimant_count).to eq 1
    end
  end

  describe '#has_multiple_claimants?' do
    context 'claim with multiple claimants' do
      subject { create :claim }
      specify { expect(subject.has_multiple_claimants?).to be_truthy }
    end
    context 'claim with a single claimant' do
      subject { create :claim, :single_claimant }
      specify { expect(subject.has_multiple_claimants?).to be_falsey }
    end
  end

  describe 'bitmasked attributes' do
    %i<discrimination_claims pay_claims desired_outcomes>.each do |attr|
      specify { expect(subject.send attr).to be_an(Array) }
    end
  end

  describe '#attracts_higher_fee?' do
    context 'when there are no claims of discrimination or unfair dismissal' do
      its(:attracts_higher_fee?) { is_expected.to be false }
    end

    context 'when there is a claim of discrimination' do
      before { subject.discrimination_claims << :race }
      its(:attracts_higher_fee?) { is_expected.to be true }
    end

    context 'when there is a claim of unfair dismissal' do
      before { subject.is_unfair_dismissal = true }
      its(:attracts_higher_fee?) { is_expected.to be true }
    end

    context 'when claim is whistleblowing' do
      before { subject.is_whistleblowing = true }
      its(:attracts_higher_fee?) { is_expected.to be true }
    end

    context 'when there are claims of both discrimination and unfair dismissal' do
      before do
        subject.discrimination_claims << :race
        subject.is_unfair_dismissal = true
      end

      its(:attracts_higher_fee?) { is_expected.to be true }
    end

    context 'when there are claims of both discrimination and whistleblowing' do
      before do
        subject.discrimination_claims << :race
        subject.is_whistleblowing = true
      end

      its(:attracts_higher_fee?) { is_expected.to be true }
    end

    context 'when there are claims of both unfair dismissal and whistleblowing' do
      before do
        subject.is_unfair_dismissal = true
        subject.is_whistleblowing = true
      end

      its(:attracts_higher_fee?) { is_expected.to be true }
    end

    context 'when there are claims of discrimination, unfair dismissal, whistleblowing' do
      before do
        subject.discrimination_claims << :race
        subject.is_unfair_dismissal = true
        subject.is_whistleblowing = true
      end

      its(:attracts_higher_fee?) { is_expected.to be true }
    end
  end

  describe '#submittable?' do
    let(:attributes) do
      {
        primary_claimant:   Claimant.new,
        primary_respondent: Respondent.new
      }
    end

    context 'when the minimum information is incomplete' do
      it 'returns false' do
        expect(attributes.none? { |key, _| described_class.new(attributes.except key).submittable? }).to be true
      end
    end

    context 'when the minimum information is complete' do
      subject { described_class.new attributes }
      its(:submittable?) { is_expected.to be true }
    end
  end

  describe '#fee_calculation' do
    it 'delegates to ClaimFeeCalculator.calculate' do
      expect(ClaimFeeCalculator).to receive(:calculate).with claim: subject
      subject.fee_calculation
    end
  end

  describe '#payment_applicable?' do
    before do
      allow(PaymentGateway).to receive(:available?).and_return true
      allow(subject).to receive(:fee_group_reference?).and_return true
      allow(ClaimFeeCalculator).to receive(:calculate).with(claim: subject).
        and_return double(ClaimFeeCalculator::Calculation, :fee_to_pay? => true)
    end

    context 'when the payment gateway is up, a fee group reference is present, and a payment is due' do
      it 'is true' do
        expect(subject.payment_applicable?).to be true
      end
    end

    context 'but the payment gateway is unavailable' do
      before { allow(PaymentGateway).to receive(:available?).and_return false }

      it 'returns false' do
        expect(subject.payment_applicable?).to be false
      end
    end

    context 'when the fee group reference is missing' do
      before { allow(subject).to receive(:fee_group_reference?).and_return false }

      it 'returns false' do
        expect(subject.payment_applicable?).to be false
      end
    end

    context 'when the application fee after remissions are applied is zero' do
      before do
        allow(ClaimFeeCalculator).to receive(:calculate).with(claim: subject).
          and_return double(ClaimFeeCalculator::Calculation, :fee_to_pay? => false)
      end

      it 'returns false' do
        expect(subject.payment_applicable?).to be false
      end
    end
  end

  describe '#state' do
    describe 'for a new record' do
      it 'is "created"' do
        expect(subject.state).to eq('created')
      end
    end
  end

  describe "#attachments" do
    subject { create :claim, :with_pdf }

    it "returns a list of attachment uplaoders on the claim" do
      subject.attachments.each do |a|
        expect(a).to be_kind_of CarrierWave::Uploader::Base
      end
    end

    specify { expect(subject.attachments.size).to eq 3 }

    it "only returns attachments that exist" do
      expect { subject.remove_claim_details_rtf! }.
        to change { subject.attachments.size }.
        from(3).to(2)
    end
  end

  describe '#remove_pdf!' do
    before { subject.pdf = pdf }

    it 'removes the pdf' do
      expect { subject.remove_pdf! }.
        to change { subject.pdf_present? }.
        from(true).to(false)
    end
  end

  describe '#remove_claim_details_rtf!' do
    before { subject.claim_details_rtf = Tempfile.new('suchclaimdetails') }

    it 'removes the rtf file' do
      expect { subject.remove_claim_details_rtf! }.
        to change { subject.claim_details_rtf.present? }.
        from(true).to(false)
    end
  end

  describe "#generate_pdf!" do
    subject { create :claim }

    before { allow(subject).to receive(:create_event) }

    context 'claim without a pdf assigned' do
      it "assigns a pdf to the model" do
        subject.generate_pdf!
        expect(subject[:pdf]).to eq "et1_barrington_wrigglesworth.pdf"
        expect(subject.pdf.file).not_to be_nil
      end

      it 'generates a log event' do
        expect(subject).to receive(:create_event).with 'pdf_generated'
        subject.generate_pdf!
      end
    end

    context 'claim with a pdf already assigned' do
      before { subject.pdf = pdf }
      it 'removes the existing pdf before creating another' do
        expect(subject).to receive(:remove_pdf!)
        expect(PdfFormBuilder).to receive(:build)
        subject.generate_pdf!
      end
    end
  end

  describe '#submit!' do
    context 'transitioning state from "created"' do
      context 'when the claim is in a submittable state' do
        before { allow(subject).to receive_messages :submittable? => true, :save! => true }

        context 'and payment is required' do
          before { allow(subject).to receive(:payment_applicable?).and_return true }

          it 'transitions state to "payment_required"' do
            subject.submit!
            expect(subject.state).to eq('payment_required')
          end

          it 'creates a pdf generation job' do
            expect(PdfGenerationJob).to receive(:perform_later).with subject
            subject.submit!
          end
        end

        context 'and payment is not required' do
          before { allow(subject).to receive(:payment_applicable?).and_return false }

          it 'transitions state to "enqueued_for_submission"' do
            subject.submit!
            expect(subject.state).to eq('enqueued_for_submission')
          end

          it 'creates a claim submission job' do
            expect(ClaimSubmissionJob).to receive(:perform_later).with subject
            subject.submit!
          end

          it 'saves the claim' do
            expect(subject).to receive(:save!)
            subject.submit!
          end

          it 'creates a log event' do
            expect(subject).to receive(:create_event).with 'enqueued'
            subject.submit!
          end
        end
      end

      context 'when the claim is not in a submittable state' do
        before { allow(subject).to receive(:submittable?).and_return false }

        it 'raises "StateMachine::InvalidTransition"' do
          expect { subject.submit! }.to raise_error StateMachine::InvalidTransition
        end
      end
    end
  end

  describe '#enqueue' do
    context 'transitioning state from "payment_required"' do
      before do
        allow(subject).to receive_messages :save! => true
        subject.state = 'payment_required'
      end

      it 'transitions state to "enqueued_for_submission"' do
        subject.enqueue!
        expect(subject.state).to eq('enqueued_for_submission')
      end

      it 'creates a claim submission job' do
        expect(ClaimSubmissionJob).to receive(:perform_later).with subject
        subject.enqueue!
      end

      it 'saves the claim' do
        expect(subject).to receive(:save!)
        subject.enqueue!
      end

      it 'creates a log event' do
        expect(subject).to receive(:create_event).with 'enqueued'
        subject.enqueue!
      end
    end
  end

  describe '#finalize!' do
    context 'transitioning state from "enqueued_for_submission"' do
      before do
        allow(subject).to receive_messages :save! => true
        subject.state = 'enqueued_for_submission'
      end

      it 'transitions state to "submitted"' do
        subject.finalize!
        expect(subject.state).to eq('submitted')
      end

      it 'saves the claim' do
        expect(subject).to receive(:save!)
        subject.finalize!
      end
    end
  end

  describe '#build_primary_claimant' do
    let(:claimant) { subject.build_primary_claimant }

    it 'sets primary_claimant as true' do
      expect(claimant.primary_claimant).to be true
    end
  end

  describe '#payment_fee_group_reference' do
    context 'when payment_attempts is 0' do
      it 'is the same as the fee group reference' do
        expect(subject.payment_fee_group_reference).
          to eq subject.fee_group_reference
      end
    end

    context 'when payment_attempts is > 0' do
      before { subject.payment_attempts = 100 }

      it 'equals "#{fee_group_reference}-#{payment_attempts}"' do
        expect(subject.payment_fee_group_reference).
          to eq "#{subject.fee_group_reference}-#{subject.payment_attempts}"
      end
    end
  end

  describe '#immutable?' do
    context 'when `state` is' do
      context 'created' do
        before { subject.state = 'created' }

        it 'is false' do
          expect(subject).not_to be_immutable
        end
      end

      context 'payment_required' do
        before { subject.state = 'payment_required' }

        it 'is false' do
          expect(subject).not_to be_immutable
        end
      end

      context 'submitted' do
        before { subject.state = 'submitted' }

        it 'is true' do
          expect(subject).to be_immutable
        end
      end

      context 'enqueued_for_submission' do
        before { subject.state = 'enqueued_for_submission' }

        it 'is true' do
          expect(subject).to be_immutable
        end
      end
    end
  end

  describe '#create_event' do
    let(:event) { subject.events.last }

    it 'creates an event on the claim with the current state of the claim' do
      subject.create_event 'lel', message: 'funny'

      { event: 'lel', actor: 'app', message: 'funny', claim_state: 'created' }.each do |k, v|
        expect(event[k]).to eq v
      end
    end

    it 'can override the actor' do
      subject.create_event 'lel', actor: 'user'
      expect(event[:actor]).to eq 'user'
    end
  end
end
