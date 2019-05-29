module ET1
  module Test
    module S3Helpers
      def self.configured_test_client
        s3_config = {
          region: ENV.fetch('AWS_REGION', 'us-east-1'),
          access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', 'accessKey1'),
          secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', 'verySecretKey1'),
          endpoint: ENV.fetch('AWS_ENDPOINT', 'http://localhost:9000/'),
          force_path_style: ENV.fetch('AWS_S3_FORCE_PATH_STYLE', 'true') == 'true'
        }
        Aws::S3::Client.new(s3_config)
      end

      def self.keys_in_bucket
        bucket_objects = configured_test_client.list_objects(
          bucket: ENV.fetch('S3_DIRECT_UPLOAD_BUCKET', 'et1directbuckettest')
        ).to_h

        bucket_objects[:contents].map do |bucket|
          bucket[:key]
        end
      end
    end
  end
end
