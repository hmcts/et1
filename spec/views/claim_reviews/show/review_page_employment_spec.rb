require "rails_helper"

describe "claim_reviews/show.html.slim" do
  context "employment" do
    include_context 'with controller dependencies for reviews'
    let(:review_page) do
      ET1::Test::ReviewPage.new
    end

    let(:null_object) { NullObject.new }
    before do
      view.singleton_class.class_eval do
        def claim_path_for(*)
          '/anything'
        end
      end
      render template: "claim_reviews/show", locals: {
        claim: claim,
        primary_claimant: claim.primary_claimant || null_object,
        representative: claim.representative || null_object,
        employment: claim.employment || null_object,
        respondent: claim.primary_respondent || null_object,
        secondary_claimants: claim.secondary_claimants,
        secondary_respondents: claim.secondary_respondents
      }
      review_page.load(rendered)
    end

    let(:employment_section) { review_page.employment_section }

    let(:employment) do
      build :employment, default_employment_attributes.merge(employment_attributes)
    end
    let(:employment_attributes) { {} }

    let(:default_employment_attributes) do
      {
        start_date: Date.civil(2000, 2, 1),
        average_hours_worked_per_week: 40.0,
        gross_pay: 500, pay_period_type: 'weekly', net_pay: 490,
        enrolled_in_pension_scheme: false,
        benefit_details: 'Company car', current_situation: 'employment_terminated',
        end_date: Date.civil(2010, 12, 1),
        worked_notice_period_or_paid_in_lieu: false,
        notice_period_end_date: Date.civil(2010, 12, 2), notice_pay_period_count: 4,
        notice_pay_period_type: 'weeks', new_job_start_date: Date.civil(2011, 1, 1),
        new_job_gross_pay: 100, new_job_gross_pay_frequency: 'monthly',
        found_new_job: true
      }
    end
    let(:claim) { create(:claim, employment: employment) }

    it { expect(employment_section.start_date.answer).to have_text '01 February 2000' }
    it { expect(employment_section.average_weekly_hours_worked.answer).to have_text 40.0 }
    it { expect(employment_section.pay_before_tax.answer).to have_text '£500.00 per week' }
    it { expect(employment_section.pay_after_tax.answer).to have_text '£490.00 per week' }
    it { expect(employment_section.pension_scheme.answer).to have_text 'No' }
    it { expect(employment_section.benefit_details.answer).to have_text 'Company car' }
    it { expect(employment_section.current_situation.answer).to have_text "No longer working for this employer" }
    it { expect(employment_section.end_date.answer).to have_text '01 December 2010' }
    it { expect(employment_section.notice_period.answer).to have_text 'No' }
    it { expect(employment_section).not_to have_notice_period_end_date }
    it { expect(employment_section).not_to have_notice_pay }
    it { expect(employment_section.another_job.answer).to have_text 'Yes' }
    it { expect(employment_section.pay_before_tax_at_new_job.answer).to have_text '£100.00 per month' }
    context "when found_new_job is false" do
      let(:employment_attributes) { { found_new_job: false } }

      it { expect(employment_section.another_job.answer).to have_text 'No' }
      it { expect(employment_section).not_to have_pay_before_tax_at_new_job }
    end

    context "when found_new_job is nil" do
      let(:employment_attributes) { { found_new_job: nil } }

      it { expect(employment_section.another_job.answer).to have_text 'Not entered' }
      it { expect(employment_section).not_to have_pay_before_tax_at_new_job }
    end

    describe 'current_situation' do
      context 'when still_employed' do
        let(:employment_attributes) { { current_situation: :still_employed, new_job_start_date: nil, new_job_gross_pay: nil } }
        it 'does not include fields pertaining to employment end date or notice period' do
          aggregate_failures 'validating fields do not exist' do
            expect(employment_section).not_to have_end_date
            expect(employment_section).not_to have_notice_period
            expect(employment_section).not_to have_notice_period_end_date
            expect(employment_section).not_to have_notice_pay
          end
        end
      end

      context 'when notice_period' do
        let(:employment_attributes) { { current_situation: :notice_period, new_job_start_date: nil, new_job_gross_pay: nil } }
        it { expect(employment_section.notice_period_end_date.answer).to have_text '02 December 2010' }
        it 'does not include fields pertaining to employment end date or notice period pay' do
          aggregate_failures 'validating fields do not exist' do
            expect(employment_section).not_to have_end_date
            expect(employment_section).not_to have_notice_pay
          end
        end
      end

      context 'when employment_terminated' do
        let(:employment_attributes) { { current_situation: :employment_terminated } }

        it 'does not include fields pertaining to employment end date or notice period pay' do
          aggregate_failures 'validating fields do not exist' do
            expect(employment_section).not_to have_notice_pay
          end
        end
      end

      describe 'when target.worked_notice_period_or_paid_in_lieu' do
        context 'is true' do
          let(:employment_attributes) { { worked_notice_period_or_paid_in_lieu: true } }

          it 'includes notice period pay' do
            expect(employment_section.notice_pay.answer).to have_text '4.0 weeks'
          end
        end

        context 'is false' do
          it 'does not include notice period pay' do
            expect(employment_section).not_to have_notice_pay
          end
        end
      end

      context 'when employment is blank' do
        let(:claim) { create(:claim, employment: nil) }
        it 'presents as not employed there' do
          expect(employment_section.employed_by_employer.answer).to have_text('No')
        end
      end
    end
  end
end
