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

# Call out to http://jsonplaceholder.typicode.com/posts
class Posts < ROM::Relation[:http]

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


Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/rom-http/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
