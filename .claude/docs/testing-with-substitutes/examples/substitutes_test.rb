require "minitest/autorun"
require_relative "sms_client"
require_relative "http_client"

# Demonstrates how Substitutes are used: assert on observable telemetry (tracked
# outputs, recorded requests), never on mock expectations.
class SubstitutesTest < Minitest::Test
  def test_output_adapter_tracks_what_it_sent
    sms = SmsClient::Substitute.build
    tracker = sms.track_sends

    sms.send_sms(to: "+15550100", body: "hello")
    sms.send_sms(to: "+15550101", body: "world")

    assert_equal(
      [{to: "+15550100", body: "hello"}, {to: "+15550101", body: "world"}],
      tracker.data
    )
  end

  def test_output_adapter_exercises_the_real_failure_path
    sms = SmsClient::Substitute.build_failing

    assert_raises(RuntimeError) { sms.send_sms(to: "+15550100", body: "hi") }
  end

  def test_input_adapter_records_requests_and_returns_queued_responses
    ok = HttpClient::Response.new(code: 200, headers: {}, body: %({"id":1}))
    http = HttpClient::Substitute.build([ok])

    response = http.get("https://example.test/widgets/1", headers: {"Accept" => "application/json"})

    assert_equal 1, response.json["id"]
    assert_equal 1, http.requests.length
    assert_equal :get, http.requests.first[:verb]
    assert_equal "https://example.test/widgets/1", http.requests.first[:url]
  end

  def test_input_adapter_raises_when_under_stubbed
    http = HttpClient::Substitute.build([])

    assert_raises(RuntimeError) { http.get("https://example.test/anything") }
  end
end
