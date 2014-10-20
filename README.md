# Restspec

Test REST APIs using RSpec.

## What is this?

I don't know about you, but i kept writing the same kind of boilerplate every time i was testing an API from RSpec. Not only specific matchers or macros but design patterns too. I tried using some node-based testing frameworks but i missed all the power of object-oriented ruby and metaprogramming. So... i decided to make it easier to test json APIs and i wrote this library.

#### Disclaimer
It's still a work in progress.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'restspec'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restspec

## Setup

**Disclaimer:** In the future there will be a kind of generator to generate all the stuff that for now have to be created manually. Sorry for that. This is the next thing in my TODO list :)

After installing the gem, just add the following lines to your `spec_helper` or `rails_helper` or whatever your RSpec helper is called.

At the top of the file:

```ruby
require 'restspec'
```

Inside the RSpec configuration block:

```ruby
config.include Restspec::RSpec::ApiHelpers, :type => :endpoint
config.extend Restspec::RSpec::ApiMacros, :type => :endpoint
```

The later two lines adds the helpers, matchers and macros to any test with the `:endpoint` type.

Then, in the end of the RSpec configuration file:

```ruby
Restspec.configure do |config|
  config.base_url = 'your.api.url/version'
  config.schema_definition = "#{File.dirname __FILE__}/api/api_schemas.rb"
  config.endpoints_definition = "#{File.dirname __FILE__}/api/api_endpoints.rb"
end
```

These three configurations (`base_url`, `schema_definition` and `endpoints_definition`) and required to make Restspec work. The first one is the api url base we will be testing; the second is where we will define our schemas and the third one is where we will define our endpoints. For now, just create a folder inside your rspec folder called `api` and, inside that folder, creates the two configuration files:

```bash
$ mkdir -p spec/api
$ touch spec/api/api_schemas.rb
$ touch spec/api/api_endpoints.rb
```

Now, you made the work that a generator will do later. Now, write some specs.

## Documentation & Usage

First, you may be wondering about the `api_schemas.rb` file and the `api_endpoints.rb` file. The basic design of Restspec is based in the fact that your schemas and endpoints are not dependant of your tests. In this way, Restspec can provide you with matchers, macros and helpers that know how to manage the dependencies of your models and endpoints, but we will see that later. 

### Schemas

Before writing a spec, we need a definition of an api to test. Let's say that we have an api consisting of two resources: Categories and Products.

```yaml
  Category: { name }
  Product: { price, name, category_id }
```

One of the primary goals of Restspec was to provide a way to run each test independently of another. The problem with testing this simple set of resources is that the products are dependant on categories. Because we divide the schemas and endpoints from the tests, we can specify relationships between schemas and relationships in ways that they reflect this dependency. First, we will make the schemas. Let's write this in the `api_schemas.rb`:

```ruby
schema :category do
  attribute :name, string
end

schema :product do
  attribute :name, string
  attribute :price, decimal_string({
    example_options: {
      integer_part: 5,
      decimal_part: 2
    }
  })

  attribute :category_id, schema_id({
    fetch_endpoint: 'categories/index',
    create_endpoint: 'categories/create'
  })
end
```

The `schema` method allow us to define a set of attributes that conforms a schema. A schema is one of your resources. The main goals of them are:

1. Provide **validations** of what we get from the api.
2. Provide **examples** of what we should post to the api.

The first schema (`category`) should be pretty easy to understand. The second parameters of `attribute` is a type function that defines how this attribute should be validated and how to provide examples for this attribute.

The second attribute of `product` contains a type that receives a set of options. The `example_options` set is a set of options that helps with examples generation. In this case, we will generate decimals that have 5 integer parts and 2 decimal parts.

A full list of the types we can use is here:

Type | Description | Options
-----|------|-------|
boolean | True or False |
decimal_string  | Strings that contains decimals. | integer_part, decimal_part
decimal | Decimals |
integer | Numbers without decimal points | 
schema_id | Represent an id related to another schema | fetch_endpoint, create_endpoint, [create_schema, hardcoded_fallback, perform_validation]
string | Strings |

They will be expanded as more needs arises.

The final attribute on product is important to note:

```ruby
attribute :category_id, schema_id({
  fetch_endpoint: 'categories/index',
  create_endpoint: 'categories/create'
})
```

This says that the `category_id` attribute should be the `id` property of another schema. To specify how to get that `id` we should define an endpoint to fetch that id and what endpoint to use when there is no data in the fetch endpoint.

To understand correctly how this works, we should explain the endpoints.

### Endpoints

In `api_endpoints.rb`, add the following:

```ruby
namespace :categories do
  schema :category

  endpoint :index do
    method :get
    path '/categories'
  end

  endpoint :create do
    method :post
    path '/categories'
  end
end

namespace :products do
  schema :product

  endpoint :index do
    method :get
    path '/products'
  end

  endpoint :create do
    method :post
    path '/products'
  end
end
```

A namespace is a combination of endpoints that shares a schema. In this case, we are defining a namespace `categories` with the endpoints `index` and `create`. Each individual endpoint define his method and path, so he knows how it will be executed. In the `schema_id` example lines above, we referenced two of this endpoints: `categories/index` and `categories/create`. The slash is a way to indicate a namespaced endpoint.

### Specs

Finally, we'll write a spec for products. The describe block should have the `endpoint` type to get the helpers and macros.

```ruby
require 'spec_helper'

RSpec.describe 'Products endpoints', :type => :endpoint do
end
```

Inside this `describe` block, we can make some endpoint tests with the `endpoint` macro. We will use the syntax with slashes to specify which endpoint we are going to test. Then, we are going to test that the status of calling this endpoint is 200 (`OK`)

```ruby
endpoint 'products/index' do
  it { should have_status(:ok) }
end
```

Note we can use the underscored versions (`:continue`, `:ok`, `:created`, etc) of the [values specified in Rack](https://github.com/rack/rack/blob/575bbcba780d9ba71f173921aa1fcb024890b867/lib/rack/utils.rb#L573) instead of writing the http code numbers.

We can test for the response information itself using the `within_response` macro:

```ruby
endpoint 'products/index' do
  it { should have_status(:ok) }
  within_response do
    it { should have_at_least(1).item }
  end
end
```

And we can test each one of this responses to be like any schema with this:

```ruby
it 'has all his objects according to the product schema' do
  subject.each do |product|
    expect(product).to be_like_schema(:product)
  end
end
```

And because we can't be sure we already have one item to test that 1 item is here, we can use a `before(:all)` hook inside the `endpoint` block to add some elements:

```
before(:all) do
  initial_products = read_endpoint
  if initial_products.size < 3
    3.times.map { read_endpoint('products/create', body: schema_example(:product)) }
  end
end
```

The method `read_endpoint` reads an endpoint and returns the body of the response of that endpoint. After reading the endpoint, we can just add some new products using the `products/create` endpoint and some product examples obtained using the `schema_example` method.

Note that we didn't add any explicit `category_id` in the spec but the id was inferred from the schema file.

If we want to test a no-GET endpoint, we can make it like this:

```ruby
endpoint 'products/create' do
  payload { schema_example(:product) }

  it { should have_status(:created) }
  it { should be_like_schema(:product) }
end
```

We used the `payload` macro to set the request body to a generated example from the `product` schema.
