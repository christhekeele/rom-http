require 'rom/relation'

require 'rom/http/dsl'

module ROM
  module HTTP
    
    class Relation < ROM::Relation
      forward *DSL.public_instance_methods
    end

  end
end
