# rubocop:disable RSpec/MultipleExpectations
require 'rails_helper'

RSpec.describe EtApi, type: :service do
  shared_context 'with api environment variable' do
    let(:et_api_url) { 'http://api.et.net:4000/api/v2' }
    around do |example|
      ClimateControl.modify ET_API_URL: et_api_url do
        example.run
      end
    end
  end

  shared_context 'with command matcher' do
    matcher :contain_valid_api_command do |expected_command|
      chain :version do |version|
        @version = version
      end
      chain :for_db_data do |db_data|
        @db_data = db_data
      end
      errors = []

      match do |actual|
        errors = []
        json = JSON.parse(actual.body).deep_symbolize_keys[:data].detect { |command| command[:command] == expected_command }
        expect(json).to be_a_valid_api_command(expected_command).version(@version).for_db_data(@db_data) # rubocop:disable RSpec/InstanceVariable
      rescue RSpec::Expectations::ExpectationNotMetError => err
        errors << "Json did not contain valid api command for #{expected_command}"
        errors.concat(err.message.lines.map { |l| "#{'  ' * 2}#{l.gsub(/\n\z/, '')}" })
        false
      end

      failure_message do
        "Expected sent request body to be a valid api command for #{expected_command} but it wasn't\n\nThe errors reported were: #{errors.join("\n")}"

      end
    end
    matcher :contain_api_command do |expected_command|
      match do |actual|
        JSON.parse(actual.body).deep_symbolize_keys[:data].any? { |command| command[:command] == expected_command }
      end
    end
  end

  describe '.create_claim' do

    let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }

    shared_context 'with build claim endpoint recording' do
      my_request = nil
      subject(:recorded_request) { my_request }

      before do
        my_request = nil
        stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
          my_request = request
          { body: '{}', headers: { 'Content-Type': 'application/json' } }
        end
      end
    end

    shared_context 'with action performed before each example' do
      before do
        described_class.create_claim example_claim
      end
    end

    include_context 'with api environment variable'
    include_context 'with build claim endpoint recording'
    include_context 'with command matcher'

    context 'with a claim with single claimant, single respondent and a representative' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_pdf, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent (with no work address) and a representative' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_pdf, :no_attachments, :primary_respondent_with_no_work_address) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent (with no addresses) and a representative' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_pdf, :no_attachments, :primary_respondent_with_no_addresses) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent and a representative (with no address)' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_pdf, :no_attachments, :primary_representative_with_no_address) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent and no representative' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_pdf, :without_representative, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildPrimaryRepresentative') }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent, no representative and no employment' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_pdf, :without_representative, :no_attachments, :without_employment) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildPrimaryRepresentative') }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with multiple claimants, single respondent and a representative' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_pdf, :with_secondary_claimants, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.to contain_valid_api_command('BuildSecondaryClaimants').version('2').for_db_data(example_claim.secondary_claimants) }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, multiple respondents and a representative' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_pdf, :with_secondary_respondents, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildSecondaryRespondents').version('2').for_db_data(example_claim.secondary_respondents) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with multiple claimants via CSV, single respondent and a representative' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :without_rtf, :with_pdf) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.to contain_valid_api_command('BuildClaimantsFile').version('2').for_db_data(example_claim.additional_claimants_csv) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildClaimantsRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent, a representative and an rtf file' do
      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_pdf, :without_additional_claimants_csv) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.to contain_valid_api_command('BuildClaimDetailsFile').version('2').for_db_data(example_claim) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildClaimantsRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
    end

    context 'with a timeout from the API endpoint' do
      let(:example_claim) { create(:claim, :no_attachments, :without_representative) }

      before { stub_request(:post, build_claim_url).to_timeout }

      it 'raises a retryable exception' do
        expect { described_class.create_claim example_claim }.to raise_error(EtApi::Timeout) { |error| expect(error.retry?).to be true }
      end
    end

    context 'with a 422 from the API endpoint' do
      let(:example_claim) { create(:claim, :no_attachments, :without_representative) }

      before { stub_request(:post, build_claim_url).to_return(body: '{}', status: 422, headers: { 'Content-Type': 'application/json' }) }

      it 'raises a non retryable exception' do
        expect { described_class.create_claim example_claim }.to raise_error(EtApi::UnprocessableEntity) { |error| expect(error.retry?).to be false }
      end
    end

    context 'with a 400 from the API endpoint' do
      let(:example_claim) { create(:claim, :no_attachments, :without_representative) }

      before { stub_request(:post, build_claim_url).to_return(body: '{}', status: 400, headers: { 'Content-Type': 'application/json' }) }

      it 'raises a non retryable exception' do
        expect { described_class.create_claim example_claim }.to raise_error(EtApi::BadRequest) { |error| expect(error.retry?).to be false }
      end
    end

    context 'with a 500 from the API endpoint' do
      let(:example_claim) { create(:claim, :no_attachments, :without_representative) }

      before { stub_request(:post, build_claim_url).to_return(body: '{}', status: 500, headers: { 'Content-Type': 'application/json' }) }

      it 'raises a retryable exception' do
        expect { described_class.create_claim example_claim }.to raise_error(EtApi::InternalServerError) { |error| expect(error.retry?).to be true }
      end
    end
  end

  describe '.create_reference' do
    let(:create_reference_url) { "#{et_api_url}/references/create_reference" }

    shared_context 'with create reference endpoint recording' do
      my_request = nil
      subject { JSON.parse(recorded_request.body).deep_symbolize_keys }

      let(:example_response_data) do
        {
          reference: '1234567890',
          office: {
            code: '11',
            name: 'Puddletown',
            address: '1 Some road, Puddletown',
            telephone: '020 1234 5678'
          }
        }
      end
      let(:example_response_body) do
        {
          status: 'created',
          meta: {},
          uuid: SecureRandom.uuid,
          data: example_response_data
        }
      end
      let(:recorded_request) { my_request }

      before do
        my_request = nil
        stub_request(:post, create_reference_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
          my_request = request
          { body: example_response_body.to_json, headers: { 'Content-Type': 'application/json' } }
        end
      end
    end

    shared_context 'with action performed before each example' do
      before do
        described_class.create_reference postcode: example_postcode
      end
    end

    include_context 'with api environment variable'
    include_context 'with create reference endpoint recording'

    context 'with a valid post code' do
      include_context 'with action performed before each example'
      let(:example_postcode) { 'DE21 6AA' }

      it { is_expected.to be_a_valid_api_command('CreateReference').version(2).for_db_data(Address.new(post_code: example_postcode)) }
    end

    context 'with a timeout from the API endpoint' do
      let(:example_postcode) { 'DE21 6AA' }

      before { stub_request(:post, create_reference_url).to_timeout }

      it 'raises a retryable exception' do
        expect { described_class.create_reference postcode: example_postcode }.to raise_error(EtApi::Timeout) { |error| expect(error.retry?).to be true }
      end
    end

    context 'with a 422 from the API endpoint' do
      let(:example_postcode) { 'DE21 6AA' }

      before { stub_request(:post, create_reference_url).to_return(body: '{}', status: 422, headers: { 'Content-Type': 'application/json' }) }

      it 'raises a non retryable exception' do
        expect { described_class.create_reference postcode: example_postcode }.to raise_error(EtApi::UnprocessableEntity) { |error| expect(error.retry?).to be false }
      end
    end

    context 'with a 400 from the API endpoint' do
      let(:example_postcode) { 'DE21 6AA' }

      before { stub_request(:post, create_reference_url).to_return(body: '{}', status: 400, headers: { 'Content-Type': 'application/json' }) }

      it 'raises a non retryable exception' do
        expect { described_class.create_reference postcode: example_postcode }.to raise_error(EtApi::BadRequest) { |error| expect(error.retry?).to be false }
      end
    end

    context 'with a 500 from the API endpoint' do
      let(:example_postcode) { 'DE21 6AA' }

      before { stub_request(:post, create_reference_url).to_return(body: '{}', status: 500, headers: { 'Content-Type': 'application/json' }) }

      it 'raises a retryable exception' do
        expect { described_class.create_reference postcode: example_postcode }.to raise_error(EtApi::InternalServerError) { |error| expect(error.retry?).to be true }
      end
    end

    context 'with return value verified' do
      let(:example_postcode) { 'DE21 6AA' }

      it 'contains the data from the example response body' do
        value = described_class.create_reference postcode: example_postcode

        expect(value).to eql example_response_data
      end
    end
  end

  describe '.build_diversity_response' do

    let(:build_diversity_response_url) { "#{et_api_url}/diversity/build_diversity_response" }

    shared_context 'with build diversity response endpoint recording' do
      my_request = nil
      subject(:recorded_request) { JSON.parse(my_request.body).deep_symbolize_keys }

      before do
        my_request = nil
        stub_request(:post, build_diversity_response_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
          my_request = request
          { body: '{}', headers: { 'Content-Type': 'application/json' } }
        end
      end
    end

    shared_context 'with action performed before each example' do
      before do
        described_class.build_diversity_response example_diversity_response
      end
    end

    include_context 'with api environment variable'
    include_context 'with build diversity response endpoint recording'
    include_context 'with command matcher'
    context 'typical data set' do
      let(:example_diversity_response) { create :diversity }

      include_context 'with action performed before each example'
      it { is_expected.to be_a_valid_api_command('BuildDiversityResponse').version(2).for_db_data(example_diversity_response) }



    end

  end
end
# rubocop:enable RSpec/MultipleExpectations
