require "test_helper"

class SsoProviderTesterTest < ActiveSupport::TestCase
  test "oidc discovery requires exact issuer match" do
    provider = SsoProvider.new(
      strategy: "openid_connect",
      name: "pocket_id",
      label: "Pocket ID",
      issuer: "https://pocketid.example.com/",
      client_id: "client-id",
      client_secret: "secret"
    )

    response = stub(status: 200, success?: true, body: {
      issuer: "https://pocketid.example.com",
      authorization_endpoint: "https://pocketid.example.com/authorize",
      token_endpoint: "https://pocketid.example.com/api/oidc/token"
    }.to_json)

    client = stub
    client.stubs(:get).returns(response)

    tester = SsoProviderTester.new(provider)
    tester.stubs(:faraday_client).returns(client)

    result = tester.test!

    assert_not result.success?
    assert_includes result.message, "Issuer mismatch"
    assert_includes result.message, "trailing slash mismatch"
    assert_equal "https://pocketid.example.com/", result.details[:expected]
    assert_equal "https://pocketid.example.com", result.details[:actual]
  end

  test "oidc connection failure keeps raw diagnostics out of the user message" do
    provider = SsoProvider.new(
      strategy: "openid_connect",
      name: "private_oidc",
      label: "Private OIDC",
      issuer: "https://oidc.example.com",
      client_id: "client-id",
      client_secret: "secret"
    )
    raw_error = "getaddrinfo: internal-hostname with secret-value"
    client = stub
    client.stubs(:get).raises(Faraday::ConnectionFailed, raw_error)
    DebugLogEntry.expects(:capture).with do |attributes|
      assert_equal "authentication", attributes[:category]
      assert_equal "SsoProviderTester", attributes[:source]
      assert_equal "private_oidc", attributes[:provider_key]
      assert_equal "Faraday::ConnectionFailed", attributes.dig(:metadata, :error_class)
      assert_equal raw_error, attributes.dig(:metadata, :error_message)
      true
    end

    tester = SsoProviderTester.new(provider)
    tester.stubs(:faraday_client).returns(client)

    result = I18n.with_locale(:cs) { tester.test! }

    assert_not result.success?
    assert_equal I18n.t("sso_provider_tester.connection_failed_safe", locale: :cs), result.message
    assert_not_includes result.message, "internal-hostname"
    assert_not_includes result.message, "secret-value"
  end
end
