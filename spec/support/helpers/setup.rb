module ET1
  module Test
    module Setup
      def stub_build_blob_to_azure
        key = "direct_uploads/#{SecureRandom.uuid}".freeze
        azure_response = ET1::Test::AzureHelpers.url_for_direct_upload(key, expires_in: 1.hour)

        queries = Rack::Utils.parse_nested_query(URI.parse(azure_response).query)

        stub_request(:post, "#{ENV.fetch('ET_API_URL', 'http://api.et.127.0.0.1.nip.io:3100/api')}/v2/build_blob").
          to_return(
            headers: { 'Content-Type': 'application/json' },
            body:
              {
                "data": {
                  "fields": {
                    "key": key,
                    "permissions": queries['sp'],
                    "version": queries['sv'],
                    "expiry": queries['se'],
                    "resource": queries['sr'],
                    "signature": queries['sig']
                  },
                  "url": azure_response,
                  "unsigned_url": ET1::Test::AzureHelpers.configured_test_client.blob_client.generate_uri("et1-direct-bucket-test/#{key}")
                },
                "meta": {
                  "cloud_provider": "azure"
                },
                "status": "accepted",
                "uuid": SecureRandom.uuid
              }.to_json
          )
      end
    end
  end
end
