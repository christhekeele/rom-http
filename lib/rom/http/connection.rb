module ROM
  module HTTP

    # The essentials a Dataset needs to get data.
    class Connection < Struct.new(:client, :root, :options)

    end

  end
end
