require_relative './base'
module Et1
  module Test
    module JsonObjects
      module V2
        class BuildClaimJsonObject < Base
          include RSpec::Matchers
          include RSpec::Mocks::ArgumentMatchers

          def has_valid_json_for_model?(claim, errors: [], indent: 1)
            employment = claim.employment
            employment_details_matcher = if employment.present?
                                           a_hash_including(
                                             :average_hours_worked_per_week => employment.average_hours_worked_per_week,
                                             :benefit_details => employment.benefit_details,
                                             :end_date => employment.end_date.try(:strftime, '%Y-%m-%d'),
                                             :enrolled_in_pension_scheme => employment.enrolled_in_pension_scheme,
                                             :found_new_job => employment.found_new_job,
                                             :gross_pay => employment.gross_pay,
                                             :gross_pay_period_type => employment.pay_period_type,
                                             :job_title => employment.job_title,
                                             :net_pay => employment.net_pay,
                                             :net_pay_period_type => employment.pay_period_type,
                                             :new_job_gross_pay => employment.new_job_gross_pay,
                                             :new_job_start_date => employment.new_job_start_date.try(:strftime, '%Y-%m-%d'),
                                             :notice_pay_period_count => employment.notice_pay_period_count,
                                             :notice_pay_period_type => employment.notice_pay_period_type,
                                             :notice_period_end_date => employment.notice_period_end_date.try(:strftime, '%Y-%m-%d'),
                                             :start_date => employment.start_date.try(:strftime, '%Y-%m-%d'),
                                             :worked_notice_period_or_paid_in_lieu => employment.worked_notice_period_or_paid_in_lieu
                                           )
                                         else
                                           eq({})
                                         end
            expect(json[:data]).to include case_type: claim.multiple_claimants? ? 'Multiple' : 'Single',
                                           claim_details: claim.claim_details,
                                           date_of_receipt: claim.submitted_at.strftime('%FT%T.%L%:z'),
                                           desired_outcomes: claim.desired_outcomes.map(&:to_s),
                                           discrimination_claims: claim.discrimination_claims.map(&:to_s),
                                           employment_details: employment_details_matcher,
                                           is_unfair_dismissal: claim.is_unfair_dismissal,
                                           jurisdiction: claim.attracts_higher_fee? ? 2 : 1,
                                           other_claim_details: claim.other_claim_details,
                                           other_known_claimant_names: claim.other_known_claimant_names,
                                           other_outcome: claim.other_outcome,
                                           pay_claims: claim.pay_claims.map(&:to_s),
                                           reference: claim.fee_group_reference,
                                           send_claim_to_whistleblowing_entity: claim.send_claim_to_whistleblowing_entity,
                                           submission_channel: "Web",
                                           submission_reference: claim.reference,
                                           email_template_reference: 'et1-v1-en',
                                           pdf_template_reference: 'et1-v2-en',
                                           confirmation_email_recipients: claim.confirmation_email_recipients,
                                           miscellaneous_information: claim.miscellaneous_information

          rescue RSpec::Expectations::ExpectationNotMetError => err
            errors << "Missing or invalid BuildPrimaryClaimant command json"
            errors.concat(err.message.lines.map { |l| "#{'  ' * indent}#{l.gsub(/\n\z/, '')}" })
            false
          end
        end
      end
    end
  end
end
