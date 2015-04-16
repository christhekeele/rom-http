require 'spec_helper'

require 'rom/lint/spec'

describe ROM::HTTP::Dataset do
  let(:data) { ROM::HTTP::Connection.new(HTTP, 'http://jsonplaceholder.typicode.com', {}) }
  let(:dataset) { ROM::HTTP::Dataset.new(data, 'posts') }

  it_behaves_like "a rom enumerable dataset"
end
