module AfterShip
  module V4
    class Configuration
      attr_accessor :api_endpoint, :api_key
      attr_writer :timeout

      def initialize
        @api_endpoint = 'https://api.aftership.com'
        @timeout = 3
        @headers = { 'Content-Type' => 'application/json' }
      end

      def timeout
        return 0 unless @timeout

        @timeout.to_f / 1000
      end

      def headers
        @headers.merge('aftership-api-key' => api_key)
      end

      def headers= h
        @headers.merge!(h)
      end
    end
  end
end
