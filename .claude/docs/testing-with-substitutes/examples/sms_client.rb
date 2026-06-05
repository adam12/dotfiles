require_relative "event_emitter"
require_relative "output_tracker"

# OUTPUT-side adapter. Wraps an external SMS gateway.
#
#   SmsClient.build              -> real gateway (network)
#   SmsClient::Substitute.build  -> fake gateway (no network), used in tests
#
# Sends are observable via track_sends, so tests assert on what was sent rather
# than mocking the gateway.
class SmsClient
  def self.build(api_key: ENV.fetch("SMS_API_KEY"))
    new(Gateway.new(api_key))
  end

  def initialize(gateway)
    @gateway = gateway
    @emitter = EventEmitter.new
  end

  def send_sms(to:, body:)
    @gateway.deliver(to, body)
    @emitter.emit(:sent, {to: to, body: body})
  end

  # Records every :sent payload as {to:, body:}.
  def track_sends
    OutputTracker.new(@emitter, :sent)
  end

  # The real gateway (network). Body omitted — illustrative only.
  class Gateway
    def initialize(api_key)
      @api_key = api_key
    end

    def deliver(_to, _body)
      raise NotImplementedError, "real HTTP call to the SMS provider goes here"
    end
  end

  # Substitutes wire the REAL SmsClient around a fake gateway, so the adapter's
  # own logic (emitting :sent) still runs.
  module Substitute
    def self.build
      SmsClient.new(FakeGateway.new)
    end

    def self.build_failing
      SmsClient.new(FailingGateway.new)
    end

    class FakeGateway
      def deliver(_to, _body) = true
    end

    class FailingGateway
      def deliver(_to, _body)
        raise "simulated SMS delivery failure"
      end
    end
  end
end
