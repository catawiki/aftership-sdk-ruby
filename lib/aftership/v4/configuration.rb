module AfterShip
  module V4
    class Configuration
      attr_accessor :api_endpoint, :api_key, :headers
      attr_writer :timeout

      def initialize
        @api_endpoint = 'https://api.aftership.com'
        @headers = {}
        @timeout = 3
      end

      def timeout
        return 0 unless @timeout

        @timeout.to_f / 1000
      end
    end
  end
end
