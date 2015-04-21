ROM::HTTP
=========

> **HTTP support for ROM.**



Synopsis
--------

`rom-http` is an adapter that integrates the [http](https://rubygems.org/gems/http) HTTP client library with the [rom](https://rubygems.org/gems/rom) data library, allowing you to consume, transform, and even persist to external APIs.

**It's very much a work in progress. Use judiciously, and please report issues and feature requests!**



Installation
------------

To install in your project:

```bash
$ echo "gem 'rom-http'" >> Gemfile
$ bundle install
```

To install globally:

```bash
$ gem install rom-http
```



Usage
-----

### Setup

Provide the adapter with a root http url to get started:

```ruby
ROM.setup :http, 'http://jsonplaceholder.typicode.com'
```

You can also pass in a pre-configured `HTTP` client:

```ruby
client = HTTP[accept: "application/json"].basic_auth(:user => "user", :pass => "pass")
ROM.setup :http, 'http://jsonplaceholder.typicode.com', client
# The repository will use those headers with the provided basic auth settings.
```


### Relations

Define relations in the usual way:

```ruby

# Calls out to http://jsonplaceholder.typicode.com/posts
class Posts < ROM::Relation[:http]

  # Calls out to http://jsonplaceholder.typicode.com/posts/:id
  def by_id(id)
    get id
  end

end

rom = ROM.finalize

rom.relation(:posts).to_a
=begin
[
  {
    "userId"=>1,
    "id"=>1,
    "title"=>"sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    "body"=>"quia et suscipit\nsuscipit recusandae consequuntur expedita et cum..."
  {
    "userId"=>1,
    "id"=>2,
    "title"=>"qui est esse",
    "body"=>"est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores..."
  }
  #...
]
=end

rom.relation(:posts).by_id(1)
=begin
[
  {
    "userId"=>1,
    "id"=>1,
    "title"=>"sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    "body"=>"quia et suscipit\nsuscipit recusandae consequuntur expedita et cum..."
  }
]
=end
```


### Dataset DSL

The underlying dataset available to you in your relations leverages a simple wrapper DSL around `http` that allows you to compose requests:

```ruby

class Posts < ROM::Relation[:http]

  def example_usage(*args)

    # Generally, you won't need to access the raw `dataset` object.
    # You definitely don't want to `.call` it or enumerate it inside of the relationship–
    # let ROM do that for you. However, for rigor:

    # By default, this is a request to GET from root_url/relation_name:
    dataset

    # To actually perform the HTTP call:
    dataset.call

    # To perform the call, parse the body, and enumerate over the results:
    dataset.each do |post|
      puts post
    end

    # The rest of the DSL delegates to the dataset object, allowing you to modify the request you send:

    # HTTP verb methods allow you to modify the verb and append to the path in the same go:

    # Append 'foobar' to the request: GET from root_url/relation_name/foobar
    get 'foobar'

    # Append 'foobar' to the request, use query string parameters: GET from root_url/relation_name/foobar?fizz=buzz
    get 'foobar', params: { fizz: :buzz }

    # Make a request to POST to root_url/relation_name with an encoded form
    post form: { fizz: :buzz }

    # Make a request to POST to root_url/relation_name with a raw body
    post body: "foo=42&bar=baz"

    # Make a request to POST to root_url/relation_name with a JSON body
    post json: { fizz: :buzz }

    # Make a request to PUT to root_url/relation_name/1 with a JSON body
    put 1, json: { fizz: :buzz }

    # Verbs can be chained to re-write the verb, allowing you to reuse requests as different types:
    # Make a request to PUT to root_url/relation_name/1 with an encoded body
    post(form: {fizz: :buzz}).put(1)

    # Finally, the rest of the `http` library dsl is available to modify other parts of the request:
    get('foobar').headers("Cookie" => "9wq3w").basic_auth(:user => "user", :pass => "pass").accept(:json)

  end

end
```

Most frequently in your relations, you'll just be making simple get requests to an endpoint, and using commands to do more involved things.


### Commands



Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/rom-http/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
