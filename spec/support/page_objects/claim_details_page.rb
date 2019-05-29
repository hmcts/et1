require_relative './base_page'
module ET1
  module Test
    class ClaimDetailsPage < BasePage
      set_url "/en/apply/claim-details"

      section :rtf_file_upload, 'details' do
      include ET1::Test::UploadHelper
      include ET1::Test::I18n
        element :expander, 'summary', text: 'Or upload it as a separate document'

        def expand
          expander.click if parent.find('details')['open'] === nil
        end

        def collapse
          expander.click if parent.find('details')['open'] === 'true'
        end

        element :upload_error, '.dz-error-message', text: "You can't upload files of this type"


        def attach_additional_information_file(file_path)
          page.execute_script <<-JS
            fakeFileInput = window.$('<input/>').attr(
              {id: 'fakeFileInput', type:'file'}
            ).appendTo('details');
          JS

          force_remote do
            attach_file("fakeFileInput", file_path)
          end

          page.execute_script("var fileList = [fakeFileInput.get(0).files[0]]")
          page.execute_script <<-JS
              var e = jQuery.Event('drop', { dataTransfer : { files : [fakeFileInput.get(0).files[0]] } });
              $('.dropzone')[0].dropzone.listeners[0].events.drop(e);
          JS
          sleep 2
          page.has_content?(t('review.claim_details.remove_upload'))
        end

        def remove_rtf
          click_link(t('review.claim_details.remove_upload'))
        end
      end

      element :continue_button, 'input[type="submit"]'

      def next
        continue_button.click
      end

    end
  end
end
