# TODO: Remove this patch once azure-storage has been patched (RST-1797)

# We all hate patches - I know !!
#
# But, at the moment, active storage can only work with azure-storage gem 0.15.0.preview (it has been in this state for over a year !!)
# I have put in a PR for this change into azure-storage-ruby gem - but we will see if it gets merged.  In the mean time, we must put
# up with this patch to allow us to parse xml data from both azure and azurite (test environments).
#
# The only change is the addition of ', nil, nil, Nokogiri::XML::ParseOptions::DEFAULT_XML | Nokogiri::XML::ParseOptions::NOBLANKS' to the Nokogiri.Slop call
# which does at it says on the tin - if we have blank nodes containing just whitespace (\n was the culprit)
#
# So, to prevent you going mad when you upgrade for a different reason, this patch will deliberately fail, forcing you to come back to this file
# and read this comment - then deciding if the patch is still needed.

require 'azure/storage'
require 'azure/storage/version'
if Azure::Storage::Version.to_s != '0.15.0.preview'
  raise "The patch in #{__FILE__} is only compatible with 0.15.0.preview - please check if PR https://github.com/Azure/azure-storage-ruby/pull/140 has been merged into your version"
end
require "azure/storage/service/serialization"

module Azure::Storage
  module Service
    module Serialization
      module ClassMethods
        def slopify(xml)
          node = (xml.is_a? String) ? Nokogiri.Slop(xml, nil, nil, Nokogiri::XML::ParseOptions::DEFAULT_XML | Nokogiri::XML::ParseOptions::NOBLANKS).root : xml
          node.slop! if node.is_a? Nokogiri::XML::Document unless node.respond_to? :method_missing
          node = node.root if node.is_a? Nokogiri::XML::Document
          node
        end
      end
    end
  end
end
