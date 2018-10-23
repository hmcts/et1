require_relative '../sections'
require_relative '../messaging'
module ET1
  module Test
    class BasePage < ::SitePrism::Page
      element :google_tag_manager_head_script, :xpath, XPath.generate {|x| x.css('head script')[x.string.n.contains("googletagmanager")]}, visible: false
      element :google_tag_manager_body_noscript, :xpath, XPath.generate {|x| x.css('body noscript')[x.child(:iframe)[x.attr(:src).contains('googletagmanager')]]}
      def has_google_tag_manager_sections_for?(account)
        google_tag_manager_head_script.native.inner_html.include?(account) &&
          google_tag_manager_body_noscript.native.inner_html.include?(account)
      end

      def has_no_google_tag_manager_sections?
        has_no_google_tag_manager_head_script? && has_no_google_tag_manager_body_noscript?
      end
    end
  end
end
