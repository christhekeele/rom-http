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
            self.class.new fork_connection(connection, __method__, *args), path, verb, options
          end
        RUBY
      end

      # def persistent(&block)
      #   self.class.new fork_connection(connection, :persistent, connection.root, &block), path, verb, options
      # end

      OPTIONS_MUTATORS = [:params, :body, :form]


      OPTIONS_MUTATORS.each do |dsl|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{dsl}(value = nil, &block)
            self.class.new connection, path, verb, fork_options(__method__, self.options, value, &block)
          end
        RUBY
      end

    private

      def fork_connection(connection, method, *args)
        connection.dup.tap do |conn|
          conn.client = conn.client.send(method, *args, &block)
        end
      end

      def fork_options(option, options, value, &block)
        old_value = old_option(options, option)
        value = merge_option(old_value, value) if mergeable_options?(old_value, value)
        options.merge option => block_given? ? yield << value : value
      end

      def old_option(options, option)
        options.fetch option, case option
          when :params then {}
          when :body   then ''
          when :form   then {}
        end
      end

      def merge_option(old_value, value)
        case old_value
        when Hash   then old_value.merge(value)
        when Array  then old_value.concat(value)
        when String then old_value.concat(value)
        end
      end

      def mergeable_options?(old_value, value)
        old_value.class == value.class and [Hash, Array, String].include? old_value.class
      end

    end
  end
end
