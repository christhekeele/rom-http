module ROM
  module HTTP
    module DSL

      VERBS.each do |verb|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{verb}(path = '', options = {})
            path, options = '', path if path.kind_of? Hash
            self.class.new connection, merge_paths(self.path, path), __method__, self.options.merge(options)
          end
        RUBY
      end

      CLIENT_MUTATORS = [:via, :through, :stream, :follow, :with_follow, :with_cache, :with_headers, :with, :accept, :auth, :basic_auth]

      CLIENT_MUTATORS.each do |dsl|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{dsl}(*args)
            self.class.new fork(connection, __method__, *args), path, verb, options
          end
        RUBY
      end

      def persistent(&block)
        self.class.new fork(connection, :persistent, connection.root, &block), path, verb, options
      end

    private

      def fork(connection, method, *args, &block)
        connection.dup.tap do |conn|
          conn.client = conn.client.send(method, *args, &block)
        end
      end

    end
  end
end
