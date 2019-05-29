# frozen_string_literal: true

module ET1
  module Test
    module AzureHelpers

      ACCOUNT_NAME = 'devstoreaccount1'
      ACCESS_KEY = 'Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=='
      CONTAINER_NAME = 'et1-direct-bucket-test'

      def self.configured_test_client
        @configured_test_client ||= Azure::Storage.client options
      end

      def self.configure_test_container
        direct_container_name = CONTAINER_NAME

        direct_upload_containers = configured_test_client.blob_client.list_containers
        if direct_upload_containers.map(&:name).include?(direct_container_name)
          Rails.logger.info "Azure already has container #{direct_container_name}"
        else
          begin
            configured_test_client.blob_client.create_container(direct_container_name)
          rescue Azure::Core::Http::HTTPError
            Rails.logger.warn "AZURE: Potential race condition, attempted to create container despite detecting it as non-existent"
          end
          Rails.logger.info "Container #{direct_container_name} added to azure"
        end
      end

      def self.configured_signer
        Azure::Storage::Core::Auth::SharedAccessSignature.new(ACCOUNT_NAME, ACCESS_KEY)
      end

      def self.url_for_direct_upload(key, expires_in:)
        configured_signer.signed_uri(
          configured_test_client.blob_client.generate_uri("#{CONTAINER_NAME}/#{key}"), false,
          service: "b",
          permissions: "rw",
          expiry: expires_in ? Time.now.utc.advance(seconds: expires_in).iso8601 : nil
        ).to_s
      end

      def self.configure_cors
        direct_upload_client = configured_test_client
        service_properties = direct_upload_client.blob_client.get_service_properties
        if service_properties.cors.cors_rules.empty?
          service_properties.cors.cors_rules = [create_cors_rules]
          direct_upload_client.blob_client.set_service_properties(service_properties)
          Rails.logger.info "Direct upload storage account now has cors configured"
        else
          Rails.logger.info "Direct upload storage account has existing cors config - cowardly refusing to touch it"
        end
      end

      def self.keys_in_container
        stored_items = configured_test_client.blob_client.list_blobs(CONTAINER_NAME)

        stored_items.map(&:name)
      end

      def self.create_cors_rules
        cors_rule = Azure::Storage::Service::CorsRule.new
        cors_rule.allowed_origins = ['*']
        cors_rule.allowed_methods = ['POST', 'GET', 'PUT', 'HEAD']
        cors_rule.allowed_headers = ['*']
        cors_rule.exposed_headers = ['*']
        cors_rule.max_age_in_seconds = 3600
        cors_rule
      end

      def self.options
        options_hash = {
          storage_account_name: ACCOUNT_NAME,
          storage_access_key: ACCESS_KEY,
          use_path_style_uri: true
        }

        options_hash[:storage_blob_host] = ENV['AZURE_STORAGE_BLOB_HOST'] if ENV.key?('AZURE_STORAGE_BLOB_HOST')
        options_hash
      end

      private_class_method :create_cors_rules, :options
    end
  end
end
