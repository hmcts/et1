module ET1
  module Test
    module UploadHelper
      def force_remote
        browser = page.send(:driver).browser
        if browser.respond_to?(:file_detector=)
          old_file_detector = browser.send(:bridge).file_detector
          browser.file_detector = lambda do |args|
            args.first.to_s
          end
        end
        yield
      ensure
        browser.file_detector = old_file_detector if browser && browser.respond_to?(:file_detector=)
      end
    end
  end
end
