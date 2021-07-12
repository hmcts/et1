require_relative './base_page'
module ET1
  module Test
    class ReviewPage < BasePage
      set_url "/en/apply/review"
      section :group_claim, :et1_review_section_labelled, 'review.group_claim.title' do
        section :group_claim, :et1_review_question_labelled, 'review.group_claim.questions.group_claim' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :csv_file_name, :et1_review_question_labelled, 'review.group_claim.questions.csv_file_name' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :number_of_additional_claimants, :et1_review_question_labelled, 'review.group_claim.questions.number_of_additional_claimants' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        sections :claimants, :et1_review_additional_claimant_labelled, 'review.group_claim.claimant_header' do
          include RSpec::Matchers
          include ET1::Test::I18n
          section :full_name, :et1_review_question_labelled, 'review.group_claim.claimant.questions.full_name' do
            element :answer, :css, 'dt.govuk-summary-list__value'
          end

          section :date_of_birth, :et1_review_question_labelled, 'review.group_claim.claimant.questions.date_of_birth' do
            element :answer, :css, 'dt.govuk-summary-list__value'
          end

          section :address, :et1_review_question_labelled, 'review.group_claim.claimant.questions.address' do
            element :answer, :css, 'dt.govuk-summary-list__value'
          end

          def valid_for_model?(model)
            aggregate_failures 'validating claimant' do
              expected_title = model.title.present? ? "#{t("review.group_claim.claimant.person_title.#{model.title}")} " : ''
              expect(full_name.answer).to have_text "#{expected_title}#{model.first_name} #{model.last_name}"
              expect(date_of_birth.answer).to have_text model.date_of_birth.strftime('%d %B %Y')
              a=model.address
              expect(address.answer).to have_text "#{a.building}#{a.street}#{a.locality}#{a.county}#{a.post_code}"
              valid?
            end
            true
          end

          def valid?
            expect(questions.length).to be 3
          end

          private

          elements :questions, :css, '.govuk-summary-list__row'
        end

      end
      section :additional_respondents_section, :et1_review_section_labelled, 'review.additional_respondents.title' do
        section :additional_respondents, :et1_review_question_labelled, 'review.additional_respondents.questions.additional_respondents' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        sections :respondents, :et1_review_additional_claimant_labelled, 'review.additional_respondents.respondent_header' do
          include RSpec::Matchers
          include ET1::Test::I18n
          section :name, :et1_review_question_labelled, 'review.additional_respondents.respondent.questions.name' do
            element :answer, :css, 'dt.govuk-summary-list__value'
          end

          section :acas_number, :et1_review_question_labelled, 'review.additional_respondents.respondent.questions.acas_number' do
            element :answer, :css, 'dt.govuk-summary-list__value'
          end

          section :address, :et1_review_question_labelled, 'review.additional_respondents.respondent.questions.address' do
            element :answer, :css, 'dt.govuk-summary-list__value'
          end

          def valid_for_model?(model)
            aggregate_failures 'validating respondent' do
              expect(name.answer).to have_text model.name
              expect(acas_number.answer).to have_text model.acas_early_conciliation_certificate_number
              a=model.address
              expect(address.answer).to have_text "#{a.building}#{a.street}#{a.locality}#{a.county}#{a.post_code}"
              valid?
            end
            true
          end

          def valid?
            expect(questions.length).to be 3
          end

          private

          elements :questions, :css, '.govuk-summary-list__row'
        end
      end
      section :additional_information, :et1_review_section_labelled, 'review.additional_information.title' do
        section :important_details, :et1_review_question_labelled, 'review.additional_information.questions.important_details' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
      end
      section :claim_details, :et1_review_section_labelled, 'review.claim_details.title' do
        section :claim_details, :et1_review_question_labelled, 'review.claim_details.questions.claim_details' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :other_known_claimants, :et1_review_question_labelled, 'review.claim_details.questions.other_known_claimants' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :attached_documents, :et1_review_question_labelled, 'review.claim_details.questions.attached_documents' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
      end
      section :claim_outcome_section, :et1_review_section_labelled, 'review.claim_outcome.title' do
        section :what_outcome, :et1_review_question_labelled, 'review.claim_outcome.questions.what_outcome' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :outcome_details, :et1_review_question_labelled, 'review.claim_outcome.questions.outcome_details' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
      end
      section :claim_type_section, :et1_review_section_labelled, 'review.claim_type.title' do
        section :send_to_whistleblowing_body, :et1_review_question_labelled, 'review.claim_type.questions.send_to_whistleblowing_body' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :whistleblowing, :et1_review_question_labelled, 'review.claim_type.questions.whistleblowing' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :types, :et1_review_question_labelled, 'review.claim_type.questions.types' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
      end
      section :claimant_section, :et1_review_section_labelled, 'review.claimant.title' do
        section :date_of_birth, :et1_review_question_labelled, 'review.claimant.questions.date_of_birth' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :preferred_contact, :et1_review_question_labelled, 'review.claimant.questions.preferred_contact' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :allow_video_attendance, :et1_review_question_labelled, 'review.claimant.questions.allow_video_attendance' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :address, :et1_review_question_labelled, 'review.claimant.questions.address' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :email, :et1_review_question_labelled, 'review.claimant.questions.email' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :assistance_required, :et1_review_question_labelled, 'review.claimant.questions.assistance_required' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :full_name, :et1_review_question_labelled, 'review.claimant.questions.full_name' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :mobile, :et1_review_question_labelled, 'review.claimant.questions.mobile' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :phone, :et1_review_question_labelled, 'review.claimant.questions.phone' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :gender, :et1_review_question_labelled, 'review.claimant.questions.gender' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
      end
      section :employment_section, :et1_review_section_labelled, 'review.employment.title' do
        section :pension_scheme, :et1_review_question_labelled, 'review.employment.questions.pension_scheme' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :notice_period, :et1_review_question_labelled, 'review.employment.questions.notice_period' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :end_date, :et1_review_question_labelled, 'review.employment.questions.end_date' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :start_date, :et1_review_question_labelled, 'review.employment.questions.start_date' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :pay_before_tax, :et1_review_question_labelled, 'review.employment.questions.pay_before_tax' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :pay_after_tax, :et1_review_question_labelled, 'review.employment.questions.pay_after_tax' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :average_weekly_hours_worked, :et1_review_question_labelled, 'review.employment.questions.average_weekly_hours_worked' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :current_situation, :et1_review_question_labelled, 'review.employment.questions.current_situation' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :job, :et1_review_question_labelled, 'review.employment.questions.job' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :benefit_details, :et1_review_question_labelled, 'review.employment.questions.benefit_details' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :another_job, :et1_review_question_labelled, 'review.employment.questions.another_job' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :notice_pay, :et1_review_question_labelled, 'review.employment.questions.notice_pay' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :notice_period_end_date, :et1_review_question_labelled, 'review.employment.questions.notice_period_end_date' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :pay_before_tax_at_new_job, :et1_review_question_labelled, 'review.employment.questions.pay_before_tax_at_new_job' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :employed_by_employer, :et1_review_question_labelled, 'review.employment.questions.employed_by_employer' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
      end
      section :representative_section, :et1_review_section_labelled, 'review.representative.title' do
        section :type_of_representative, :et1_review_question_labelled, 'review.representative.questions.type_of_representative' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :email, :et1_review_question_labelled, 'review.representative.questions.email' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :address, :et1_review_question_labelled, 'review.representative.questions.address' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :full_name, :et1_review_question_labelled, 'review.representative.questions.full_name' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :dx_number, :et1_review_question_labelled, 'review.representative.questions.dx_number' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :mobile, :et1_review_question_labelled, 'review.representative.questions.mobile' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :preferred_contact, :et1_review_question_labelled, 'review.representative.questions.preferred_contact' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :phone, :et1_review_question_labelled, 'review.representative.questions.phone' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :organisation_name, :et1_review_question_labelled, 'review.representative.questions.organisation_name' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :representative, :et1_review_question_labelled, 'review.representative.questions.representative' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
      end
      section :respondent_section, :et1_review_section_labelled, 'review.respondent.title' do
        section :name, :et1_review_question_labelled, 'review.respondent.questions.name' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :address, :et1_review_question_labelled, 'review.respondent.questions.address' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :phone, :et1_review_question_labelled, 'review.respondent.questions.phone' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :acas_number, :et1_review_question_labelled, 'review.respondent.questions.acas_number' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
        section :work_address, :et1_review_question_labelled, 'review.respondent.questions.work_address' do
          element :answer, :css, 'dt.govuk-summary-list__value'
        end
      end
      section :email_confirmation_section, :fieldset_translated, 'review.email_confirmation.title' do
        include EtTestHelpers::Section

        # @!method email_recipients
        #   A govuk collection of checkboxes component for unfair dismissal question
        #   @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
        section :email_recipients, govuk_component(:collection_check_boxes), :govuk_collection_check_boxes, :'review.email_confirmation.email_recipients.label'
      end
      def edit_section(section_name)
        query = XPath.generate { |x| x.descendant(:a)[x.string.n.equals('Edit') & x.ancestor(:h2)[x.string.n.starts_with(section_name)]] }
        find(:xpath, query).click
      end
    end
  end
end
