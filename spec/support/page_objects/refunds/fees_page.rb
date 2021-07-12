require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class FeesPage < BasePage
        section :form_error_message, govuk_component(:error_summary), :govuk_error_summary, "Provide information in the highlighted fields."
        element :help, '[data-behavior=help]'
        # @!method original_claim_fees
        #   A govuk fieldset component
        #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
        section :original_claim_fees, govuk_component(:fieldset), :govuk_fieldset, 'Complete the relevant fields for fees you have paid' do
          include EtTestHelpers::Section
          # @!method et_issue
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :et_issue, govuk_component(:fieldset), :govuk_fieldset, 'ET Issue' do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            section :fee_question, govuk_component(:text_field), :govuk_text_field, 'Fee'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            section :payment_date_question, govuk_component(:date_field), :govuk_date_field, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            section :payment_date_unknown_question, govuk_component(:checkbox), :govuk_checkbox, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            section :payment_method_question, govuk_component(:collection_select), :govuk_collection_select, 'Payment method'
          end

          # @!method et_hearing
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :et_hearing, govuk_component(:fieldset), :govuk_fieldset, 'ET Hearing' do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            section :fee_question, govuk_component(:text_field), :govuk_text_field, 'Fee'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            section :payment_date_question, govuk_component(:date_field), :govuk_date_field, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            section :payment_date_unknown_question, govuk_component(:checkbox), :govuk_checkbox, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            section :payment_method_question, govuk_component(:collection_select), :govuk_collection_select, 'Payment method'
          end

          # @!method et_reconsideration
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :et_reconsideration, govuk_component(:fieldset), :govuk_fieldset, 'ET Reconsideration' do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            section :fee_question, govuk_component(:text_field), :govuk_text_field, 'Fee'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            section :payment_date_question, govuk_component(:date_field), :govuk_date_field, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            section :payment_date_unknown_question, govuk_component(:checkbox), :govuk_checkbox, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            section :payment_method_question, govuk_component(:collection_select), :govuk_collection_select, 'Payment method'
          end

          # @!method eat_issue
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :eat_issue, govuk_component(:fieldset), :govuk_fieldset, 'EAT Issue' do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            section :fee_question, govuk_component(:text_field), :govuk_text_field, 'Fee'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            section :payment_date_question, govuk_component(:date_field), :govuk_date_field, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            section :payment_date_unknown_question, govuk_component(:checkbox), :govuk_checkbox, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            section :payment_method_question, govuk_component(:collection_select), :govuk_collection_select, 'Payment method'
          end

          # @!method eat_hearing
          #   A govuk fieldset component
          #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
          section :eat_hearing, govuk_component(:fieldset), :govuk_fieldset, 'EAT Hearing' do
            include EtTestHelpers::Section
            # @!method fee_question
            #   A govuk text field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKTextField] The site prism section
            section :fee_question, govuk_component(:text_field), :govuk_text_field, 'Fee'
            # @!method payment_date_question
            #   A govuk date field component wrapping the inputs, label, hint etc.. for a date question
            #   @return [EtTestHelpers::Components::GovUKDateField] The site prism section
            section :payment_date_question, govuk_component(:date_field), :govuk_date_field, 'Payment date'
            # @!method payment_date_unknown_question
            #   A govuk file field component wrapping the input, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
            section :payment_date_unknown_question, govuk_component(:checkbox), :govuk_checkbox, "Don't know"
            # @!method payment_method_question
            #   A govukselect component wrapping the select, label, hint etc..
            #   @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
            section :payment_method_question, govuk_component(:collection_select), :govuk_collection_select, 'Payment method'
          end

          section :total, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Total fees paid")]] }) do
            element :fee, '[data-behavior=\'total_fees\']'
          end
        end

        def has_valid_help_section?
          messages = [
            "Fees were charged in the Employment Tribunal and Employment Appeals Tribunal between 29 July 2013 and 26 July 2017",
            "A type A claim had an issue fee of £160 and a hearing fee of £230.",
            "A type B claim had an issue fee of £250 and a hearing fee of £950.",
            "An Employment Appeal Tribunal fee had a lodgement fee of £400 and a hearing fee of £1200."
          ]
          help.assert_text(messages.join("\n"))
        end

        element :save_and_continue, 'form.edit_refunds_fees input[value="Continue"]'
      end
    end

  end
end
