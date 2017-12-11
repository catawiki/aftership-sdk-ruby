require 'httpclient'
require 'json'

module AfterShip
  module V4
    class Base
      class AfterShipError < StandardError;
      end
      attr_reader :http_verb_method, :end_point, :query, :body

      def initialize(http_verb_method, end_point, query = {}, body = {})
        @http_verb_method = http_verb_method
        @end_point = end_point
        @query = query
        @body = body
        @client = HTTPClient.new

        @client.send_timeout = AfterShip.configuration.timeout
      end

      def call
        parameters = {
            :query => query,
            :body => body.to_json,
            :header => AfterShip.configuration.headers
        }

        begin
          response = @client.send(http_verb_method, url, parameters)
          cf_ray = response.headers['CF-RAY']

          return JSON.parse(response.body) if response.body

          {
            :meta => {
              :code => 500,
              :message => 'Something went wrong on AfterShip\'s end.',
              :type => 'InternalError'
            },
            :data => {
              :cf_ray => cf_ray
            }
          }
        rescue HTTPClient::SendTimeoutError
          {
            :meta => {
              :code => 408,
              :message => 'AfterShip is busy at the moment.',
              :type => 'SendTimeoutError'
            }
          }
        rescue JSON::ParserError
          {
            :meta => {
              :code => 500,
              :message => 'Something went wrong on AfterShip\'s end.',
              :type => 'InternalError'
            },
            :data => {
              :body => response.body,
              :cf_ray => cf_ray
            }
          }
        end
      end

      private

      def url
        "#{AfterShip.configuration.api_endpoint}/v4/#{end_point.to_s}"
      end
    end
  end
end
