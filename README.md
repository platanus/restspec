# Restspec

Restspec is a REST api framework built in top of RSpec to help you write robust and mantainable tests to ensure that your api behaves exactly as you want.

## Installation

Install it globally like this:

    $ gem install restspec

## Usage

For a basic tutorial of how to use Restspec, please check [this file](TODO).

### The Restspec Approach

You can skip this section but i think it will help you understand how things happens here. The Restspec design is founded in the separation of how your api components are modeled and what the actual tests are. In Restspec, you have three files intended to model your api:

- endpoints.rb
- schemas.rb
- requirements.rb

The only one that is completely necesary is the `endpoints.rb` file. This file is when you define what your endpoints are and give them names. For example, the following endpoint: `GET /users/:id/orders` can be mapped to an endpoint named `users/orders`. This name can be used to reference and execute the endpoint in the tests instead of repeating it many times.

The next one, `schemas.rb`, represents the attributes your entities are πsche

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



### Endpoints

### Schemas
