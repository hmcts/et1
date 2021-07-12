require_relative '../messaging'
module ET1
  module Test
    class BaseSection < SitePrism::Section
      include EtTestHelpers::Section
      include ::ET1::Test::I18n

      def translate_if_needed(sym_or_str)
        return sym_or_str if sym_or_str.nil? || !sym_or_str.is_a?(Symbol)

        t(sym_or_str.to_s)
      end
    end
  end
end
