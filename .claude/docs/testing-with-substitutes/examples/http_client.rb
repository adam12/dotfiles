require "net/http"
require "json"

# INPUT-side adapter. The real client performs HTTP; the Substitute returns canned
# responses in call order and records every request, so tests assert on what was
# requested and fail loudly if the code under test makes more calls than stubbed.
class HttpClient
  Response = Data.define(:code, :headers, :body) do
    def success? = (200..299).cover?(code)
    def json = JSON.parse(body)
  end

  def self.build
    new
  end

  def get(url, headers: {})
    perform(Net::HTTP::Get.new(URI(url)), headers)
  end

  def post(url, body: nil, headers: {})
    request = Net::HTTP::Post.new(URI(url))
    request.body = body
    perform(request, headers)
  end

  private

  def perform(request, headers)
    uri = request.uri
    headers.each { |key, value| request[key] = value }
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    raw = http.request(request)
    Response.new(code: raw.code.to_i, headers: raw.to_hash, body: raw.body)
  end

  # Hand it the responses a test expects, in call order. It records each request
  # and hands back one queued response per call, raising when they run out.
  module Substitute
    def self.build(responses)
      Client.new(responses)
    end

    class Client
      attr_reader :requests

      def initialize(responses)
        @responses = responses.dup
        @requests = []
      end

      def get(url, headers: {})
        record(:get, url, nil, headers)
      end

      def post(url, body: nil, headers: {})
        record(:post, url, body, headers)
      end

      private

      def record(verb, url, body, headers)
        @requests << {verb: verb, url: url, body: body, headers: headers}
        raise "HttpClient::Substitute ran out of stubbed responses" if @responses.empty?
        @responses.shift
      end
    end
  end
end
