require 'rom/http/dsl'

module ROM
  module HTTP

    # A thin wrapper around HTTP's chainability, but:
    #  - HTTP verbs don't trigger network calls, the call method does
    #  - Paths are composable off of a root url

    class Dataset < Struct.new(:connection, :path, :verb, :http)
      include DSL
      include Enumerable

      def initialize(connection, path = nil, verb = :get)
        super connection, path, verb
      end

      def call
        connection.client.send(verb, url, connection.options)
      end

      def url
        url_for merge_paths(connection.root, path)
      end

      def each(&block)
        JSON.parse(call.body).each(&block)
      end

    private

      def url_for(url)
        connection.options[:ensure_trailing_slash] ? ensure_trailing_slash(url) : url
      end

      def ensure_trailing_slash(url)
        url.end_with?('/') ? url : url + '/'
      end

      def merge_paths(*paths)
        paths.map(&:to_s).reject(&:empty?).join('/').gsub(%r{(?<!:)/+}, '/')
      end

    end
  end
end
