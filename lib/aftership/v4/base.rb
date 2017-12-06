require 'httpclient'
require 'json'

module AfterShip
  module V4
    class Base
      class AfterShipError < StandardError;
      end
      attr_reader :http_verb_method, :end_point, :query, :body

      def initialize(http_verb_method, end_point, query = {}, body = {}, options = {})
        @http_verb_method = http_verb_method
        @end_point = end_point
        @query = query
        @body = body
        @header = {
          'aftership-api-key' => AfterShip.configuration.api_key,
          'Content-Type' => 'application/json'
        }.merge(AfterShip::V4::Configuration.headers)

        @client = HTTPClient.new

        if AfterShip.configuration.timeout.present?
          @client.send_timeout = AfterShip.configuration.timeout
        end
      end

      def call
        parameters = {
            :query => query,
            :body => body.to_json,
            :header => @header
        }

        cf_ray = ''

        response = @client.send(http_verb_method, url, parameters)

        if response.headers
          cf_ray = response.headers['CF-RAY']
        end

        if response.body
          begin
            response = JSON.parse(response.body)
          rescue
            response = {
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
        else
          response = {
            :meta => {
              :code => 500,
              :message => 'Something went wrong on AfterShip\'s end.',
              :type => 'InternalError'
            },
            :data => {
            }
          }
        end

        response
      end

      private

      def url
        "#{AfterShip.configuration.api_endpoint}/v4/#{end_point.to_s}"
      end
    end
  end
end
