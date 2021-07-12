require_relative './base_page'
module ET1
  module Test
    class EmploymentDetailsPage < BasePage
      set_url "/en/apply/employment"


      # @param [ET1::Test::EmploymentUi] employment user employment inputs
      def fill_in_all(employment:)
        was_employed_question.set(employment.was_employed)
        current_situation_question.set(employment.current_situation)
        job_title_question.set(employment.job_title)
        start_date_question.set(employment.start_date)
        notice_period_end_date_question.set(employment.notice_period_end_date) if employment.current_situation.to_s.split('.').last == 'notice_period'
        end_date_question.set(employment.end_date) if employment.current_situation.to_s.split('.').last == 'employment_terminated'
        worked_notice_period_question.set(employment.worked_notice_period)
        if employment.worked_notice_period.to_s.split('.').last == 'true'
          notice_pay_period_count_question.set(employment.notice_pay_period_count)
          notice_pay_period_type_question.set(employment.notice_pay_period_type)
        end
        hours_worked_per_week_question.set(employment.hours_worked_per_week)
        pay_period_type_question.set(employment.pay_period_type)
        gross_pay_question.set(employment.gross_pay)
        net_pay_question.set(employment.net_pay)
        in_pension_scheme_question.set(employment.in_pension_scheme)
        benefits_question.set(employment.benefits)
        found_new_job_question.set(employment.found_new_job)
        if employment.found_new_job.to_s.split('.').last == 'true'
          new_job_start_date_question.set(employment.new_job_start_date)
          new_job_gross_pay_question.set(employment.new_job_gross_pay)
          new_job_pay_period_type_question.set(employment.new_job_pay_period_type)
        end
      end
      # Clicks the save and continue button
      def save_and_continue
        save_and_continue_button.submit
      end

      private

      # @!method was_employed_question
      #   A govuk radio button component for 'Have you ever been employed by the person ...' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :was_employed_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'employment.was_employed.label'

      # @!method current_situation_question
      #   A govuk radio button component for 'What is your current work situation' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :current_situation_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'employment.current_situation.label'

      # @!method job_title_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the Job title
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :job_title_question, govuk_component(:text_field), :govuk_text_field, :'employment.job_title.label'

      # @!method start_date_question
      #   A govuk date field component wrapping the input, label, hint etc.. for the start date question
      #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
      section :start_date_question, govuk_component(:date_field), :govuk_date_field, :'employment.start_date.label'

      # @!method end_date_question
      #   A govuk date field component wrapping the input, label, hint etc.. for the end date question
      #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
      section :end_date_question, govuk_component(:date_field), :govuk_date_field, :'employment.end_date.label'

      # @!method notice_period_end_date_question
      #   A govuk date field component wrapping the input, label, hint etc.. for the notice period end date question
      #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
      section :notice_period_end_date_question, govuk_component(:date_field), :govuk_date_field, :'employment.notice_period_end_date.label'

      # @!method worked_notice_period_question
      #   A govuk radio button component for 'Did you work (or get paid for) a period of notice' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :worked_notice_period_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'employment.worked_notice_period.label'

      # @!method notice_pay_period_count_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'For how many weeks or months did you get paid?'
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :notice_pay_period_count_question, govuk_component(:text_field), :govuk_text_field, :'employment.notice_pay_period_count.label'

      # @!method notice_pay_period_type_question
      #   A govuk radio button component for 'For how many weeks or months did you get paid?' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :notice_pay_period_type_question, govuk_component(:collection_radio_buttons), :xpath, XPath.generate { |x| x.descendant(:div)[x.attr(:class).contains_word('govuk-form-group') & x.child(:fieldset)[x.attr(:class).contains_word('govuk-fieldset') & x.child(:div)[x.attr(:'data-module').equals('govuk-radios') & x.descendant(:input)[x.attr(:name).equals('employment[notice_pay_period_type]')]]]] }

      # @!method hours_worked_per_week_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the hours worked per week
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :hours_worked_per_week_question, govuk_component(:text_field), :govuk_text_field, :'employment.average_hours_worked_per_week.label'

      # @!method pay_period_type_question
      #   A govuk radio button component for pay_period_type question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :pay_period_type_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'employment.pay_period_type.label'

      # @!method gross_pay_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'Pay before tax' question
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :gross_pay_question, govuk_component(:text_field), :govuk_text_field, :'employment.gross_pay.label'

      # @!method net_pay_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'Pay before tax' question
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :net_pay_question, govuk_component(:text_field), :govuk_text_field, :'employment.net_pay.label'

      # @!method in_pension_scheme_question
      #   A govuk radio button component for 'Are you a member of your employers pension ...' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :in_pension_scheme_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'employment.enrolled_in_pension_scheme.label'

      # @!method benefits_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'Did you have any benefits ...' question
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :benefits_question, govuk_component(:text_area), :govuk_text_area, :'employment.benefit_details.label'

      # @!method found_new_job_question
      #   A govuk radio button component for 'Have you got a new job?' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :found_new_job_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'employment.found_new_job.label'

      # @!method new_job_start_date_question
      #   A govuk date field component wrapping the input, label, hint etc.. for the new job start date question
      #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
      section :new_job_start_date_question, govuk_component(:date_field), :govuk_date_field, :'employment.new_job_start_date.label'


      # @!method new_job_gross_pay_question
      #   A govuk text field component wrapping the input, label, hint etc.. for the 'Pay before tax' question
      #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
      section :new_job_gross_pay_question, govuk_component(:text_field), :govuk_text_field, :'employment.new_job_gross_pay.label'

      # @!method new_job_gross_pay_period_type_question
      #   A govuk radio button component for 'Did you work (or get paid for) a period of notice' question
      #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      section :new_job_pay_period_type_question, govuk_component(:collection_radio_buttons), :govuk_collection_radio_buttons, :'employment.new_job_pay_period_type.label'

      # @!method save_and_continue_button
      #   A govuk submit button component...
      #   @return [EtTestHelpers::Components::GovUKSubmit] The site prism section
      section :save_and_continue_button, govuk_component(:submit), :govuk_submit, :'employment.save_and_continue.label'
    end
  end
end
