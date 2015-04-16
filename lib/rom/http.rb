require 'rom'

module ROM
  module HTTP

    # Verbs supported by the `http` library
    VERBS = :head, :get, :post, :put, :delete, :trace, :connect, :patch#, :options # Boy does that blow up

  end
end

require 'rom/http/relation'
require 'rom/http/repository'

require 'rom/http/version'

ROM.register_adapter(:http, ROM::HTTP)
