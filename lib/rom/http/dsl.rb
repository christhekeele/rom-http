module ROM
  module HTTP
    module DSL

      VERBS.each do |verb|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{verb}(path = '')
            self.class.new connection, merge_paths(self.path, path), __method__
          end
        RUBY
      end

      MUTATORS = [:via, :through, :stream, :follow, :with_follow, :with_cache, :with_headers, :with, :accept, :auth, :basic_auth]

      MUTATORS.each do |dsl|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{dsl}(*args)
            self.class.new connection, path, verb, http.send(__method__, *args)
          end
        RUBY
      end

      def persistent(&block)
        self.class.new connection, path, verb, http.persistent(connection.root, &block)
      end

    end
  end
end
