# Restspec [![Gem Version](https://badge.fury.io/rb/restspec.svg)](http://badge.fury.io/rb/restspec) [![Build Status](https://travis-ci.org/platanus/restspec.svg?branch=master)](https://travis-ci.org/platanus/restspec)


Restspec is a REST api framework built in top of RSpec to help you write robust and mantainable tests to ensure that your api behaves exactly as you want.

## Installation

Install it globally like this:

    $ gem install restspec

## Usage

For a basic tutorial of how to use Restspec, please check [this file](https://github.com/platanus/restspec/blob/master/docs/tutorial.md).

### The Restspec Approach

You can skip this section but i think it will help you understand how things happens here. The Restspec design is founded in the separation of how your api components are modeled and what the actual tests are. In Restspec, you have three files intended to model your api:

- endpoints.rb
- schemas.rb
- requirements.rb

The only one that is completely necesary is the `endpoints.rb` file. This file is when you define what your endpoints are and give them names. For example, the following endpoint: `GET /users/:id/orders` can be mapped to an endpoint named `users/orders`. This name can be used to reference and execute the endpoint in the tests instead of repeating it many times.

The next one, `schemas.rb`, represents the attributes your entities are made of, and the final one, `requirements.rb` only helps to ensure that some information is already present on the system when the tests begin.

When we talk about endpoints as objects to reuse, we can think of the dependencies between the endpoints as dependencies between models. We can just make the `product/show` endpoint to depend on the `products/index` and the `products/create` endpoints to make sure that the test always run with a product.

### Setup

To create a new test for a given api, just run the following command:

```bash
$ restspec my-api-tests --api-prefix=http://my-api-domain/api/v1
```

This will create a folder called `my-api-tests` with the following contents:

```
.
├── Gemfile
├── Gemfile.lock
└── spec
    ├── api
    │   └── restspec
    │       ├── endpoints.rb
    │       ├── requirements.rb
    │       ├── schemas.rb
    │       └── restspec_config.rb
    ├── spec_helper.rb
    └── support
        ├── custom_macros.rb
        └── custom_matchers.rb
```

Your tests go anywhere (you can put them in the api/ folder), the configuration file (`restspec_config.rb`) has his own documentation inside and the endpoints and schemas file are were you define the inner parts of the expected API. `requirements.rb` is a set of requirement to assert needs before some tests, like to test that an api key is valid or that the system already has some important data that can't be created through the api.

### Endpoints

In the endpoints file you can define your endpoints using an special dsl, like this:

```ruby
resources :products do
  collection do
    get :index
  end

  member do
    get :show
  end
end
```

Check the endpoint DSL documentation [here](https://github.com/platanus/restspec/blob/master/docs/endpoints.md) for more details of the available methods and options. The only important thing about them is that they are the endpoints we have to test.

### Schemas

Schemas are how your data is shaped and they enforces the shape of the your data and how to generates random examples for that. You can define schemas using a special dsl like this:

```ruby
schema :product do
  attribute :name, string
  attribute :code, string
  attribute :price, decimal | decimal_string
  attribute :category_id, schema_id(:category), :for => [:examples]
  attribute :category, embedded_schema(:category), :for => [:checks]
end

schema :category do
  attribute :name, string
end
```

As you can see, a schema is compound of attributes that are attached to one type. The types are useful for many things. The types documentation is located [here](https://github.com/platanus/restspec/blob/master/docs/types.md).

The schemas DSL documentation is located [here](https://github.com/platanus/restspec/blob/master/docs/schemas.md). Schemas are a very important part of Restspec but they are not as necesary as the endpoints.

### Tests

To actually test something, let's create any test of type `api` (because in the `restspec/restspec_config` file we added helpers and macros only for this type of tests). To test an endpoint of your api you have to use the `endpoint` macro

```ruby
endpoint 'products/index' do
end
```

To actually test an execution of the endpoint, you have to use the `test` method. Restspec tests are not unit ones because the cost of call a possible slow api can be high. Because of this, all the `it`s blocks that are under a `test` block will only execute the endpoint once. Because of this, we can test many assertions against only one api execution:

```ruby
endpoint 'products/index' do
  test do
    it { should have_status(:ok) }
    it 'returns an array' do
      expect(body).to be_kind_of(Array)
    end
  end
end
```

We can call other endpoints from inside a test. For example:

```ruby
endpoint 'products/create' do
  # ...
  test 'Without a price' do
    # This is the `payload` macro, to fill the request's payload
    payload name: 'random name'

    it 'has the price set to 0' do
      product = read_endpoint(url_params: { id: body.id })
      expect(product.price).to eq(0)
    end
  end
end
```

Aditionally, we can test an endpoint that is intended to represent an action over a resource. For example, an update can be tested like this:

```ruby
endpoint 'products/update', resource: 'products/show' do
  # initial_resource is the initial representation of the resource
  payload do
    { name: "#{initial_resource.name}-001" }
  end

  test do
    it 'updates the name' do
      # final resource is the representation of the resource after
      # the endpoint has been executed
      expect(final_resource.name).to_not eq(initial_resource.name)
      expect(final_resource.name).to eq(request.payload.name)
    end
  end
end
```

For more information about what can you do in your tests, you can see what are the [available matchers](https://github.com/platanus/restspec/blob/master/docs/matchers.md), the [available helpers](https://github.com/platanus/restspec/blob/master/docs/helpers.md) and the [available macros](https://github.com/platanus/restspec/blob/master/docs/macros.md).

### Requirements

They allow to check for something important before starting to test.

```ruby
requirement :check_warehouse_availability do
  execution do
    warehouses = read_endpoint('warehouses/index')
    if !warehouses || warehouses.empty?
      add_error "There is no warehouses in the system"
    end
  end
end
```

To use them, you have to do the following in your test:

```ruby
endpoint 'products/create' do
  ensure! :check_warehouse_availability
end
```

## A note about the Roadmap

Because the scope of this library is not small, we couldn't make a first release as small as we are acostumed. Anyway, we love to be able to deliver in small iterations, so there a [ROADMAP](https://github.com/platanus/restspec/blob/master/ROADMAP.md) file that we use to keep track of the objectives that we have. Althought many of the objectives of the gem are already done, there are more objectives that will expect to the following releases.

## Contribute

Please be sure to have the [EditorConfig](http://editorconfig.org/) plugin in your text editor to follow the guidelines proposed in the [.editorconfig](https://github.com/platanus/restspec/blob/master/.editorconfig) file. To contribute, please send us a PR and make sure that the current tests keeps working after that. You can help to complete the unit tests too.
