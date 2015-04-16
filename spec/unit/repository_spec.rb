require 'spec_helper'

require 'rom/lint/spec'

describe ROM::HTTP::Repository do
  let(:repository) { ROM::HTTP::Repository }
  let(:uri) { 'http://jsonplaceholder.typicode.com' }

  it_behaves_like "a rom repository" do
    let(:identifier) { :http }
  end
end
