require 'http'
require 'rom/repository'

require 'rom/http/connection'
require 'rom/http/dataset'

module ROM
  module HTTP
    class Repository < ROM::Repository

      # HTTP repository interface
      #
      # @overload connect(url, options)
      #   Creates an HTTP client via url, passing options
      #
      #   @param [String] url http/https URL
      #   @param [Hash] options connection options
      #
      # @overload connect(url, client, options)
      #   Re-uses HTTP client instance
      #
      #   @param [String] url http/https URL
      #   @param [HTTP::Client] client a client instance
      #   @param [Hash] options connection options
      #
      # @api public
      #
      # @example
      #   repository = ROM::HTTP::Repository.new('http://jsonplaceholder.typicode.com')
      #
      #   # Or use your own HTTP client:
      #   client = HTTP[accept: "application/json"].basic_auth(:user => "user", :pass => "pass")
      #   ROM.setup :http, 'http://jsonplaceholder.typicode.com', client
      #
      # @api public
      def initialize(url, client = client_class.new, options = {})
        client, options = client_class.new(client), client unless client.is_a? client_class
        @connection = Connection.new(client, url, options)
        @endpoints = {}
      end

      def [](name)
        endpoints[name]
      end

      def dataset(name, path = nil)
        endpoints[name] = Dataset.new(@connection, path || name.to_s)
      end

      def dataset?(name)
        endpoints.key?(name)
      end

    private

      attr_reader :endpoints

      def client_class
        ::HTTP::Client
      end

    end
  end
end
