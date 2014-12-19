# Macros

## endpoint

The `endpoint` macro generates a describe block that saves inside itself the reference of an endpoint, finding it by his full name.

```ruby
RSpec.describe :books do
  endpoint 'books/create' do
  end
end
```

It can also receive the option `:implicit_test` to set a `test` block inside it automatically:

```ruby
RSpec.describe :books do
  endpoint 'books/create', implicit_test: true do
    it { should have_status(:ok) }
  end
end
```

It can be converted in an test aware of a resource using the `resource` endpoint. This will change the endpoint execution flow to first retrieve a resource to keep track of the state of the resource before and after the endpoint execution:

```ruby
RSpec.describe :books do
  endpoint 'books/update', resource: 'books/show' do
  end
end
```

## test

`test` creates a context where the endpoint attached in the parent `endpoint` will be executed only once before the tests run. In this way, we can have a lot of tests against a single execution. It receives an optional name parameter and a set of options that are passed to the context (to enable the rspec tags support). The name, when no supplied, will be `"the happy path"` to express that the `test` macro is intended to specify different endpoint executions, typically once for each use case.


```ruby
RSpec.describe :books do
  endpoint 'books/index' do
    test do
      it { should have_status(200) }
      it { should be_like_schema_array(:book) }
      it { should have_header('Cache-Control').equals('private, max-age=0, no-cache') }
    end
  end
end
```

## payload

The `payload` macro works inside a `test` macro allowing to specify the payload of the request. It can receive a hash or a block that returns a hash for more flexibility. Usually, the payload should use the `schema_example` helper.

```ruby
RSpec.describe :books do
  endpoint 'books/create' do
    payload title: 'Title', published_at: 2.days.ago

    test do
      it { should have_status(201) }
    end
  end
end
```

## url_params

The `url_params` macro specifies url parameters to use in the endpoint call. It can be a hash or a block that returns a hash. If some of the keys of the hash is a lambda, the lambda will be executed.

```ruby
RSpec.describe :books do
  endpoint 'books/show' do
    # let's imagine: /library/:library_id/books/:id
    url_params do
      # Typically, you will use the `read_endpoint` helper to get
      # some data instead of just hardcoding numbers
      {
        id: ->{ 15 },
        library_id: 10
      }
    end

    test do
      it { should have_status(200) }
    end
  end
end
```

## query_params

The `query_params` macro specifies query parameters to use in the endpoint call. It can be a hash or a block that returns a hash. It works exactly as the `payload` method.

## within_response

This macro changes the `subject` of the tests from the response object to the `response.body` for all the tests inside this block. In this way, you can make assertions against the body of the response itself.

```ruby
RSpec.describe :books do
  endpoint 'books/index' do
    test do
      before_test do
        3.times { call_endpoint('books/create', body: schema_example(:book)) }
      end

      within_response do
        it { should have_at_least(3).items }
      end
    end
  end
end
```

## ensure!

This macro will run a requirement defined in the `requirements.rb` file. A requirement can be written like this:

```ruby
requirement :a_bank_exists do
  execution do
    banks = read_endpoint('banks/index')

    if banks.blank? || banks.size <= 0
      add_error "We need banks to work!!"
    end
  end
end
```

And can be asserted like this:

```ruby
RSpec.describe :accounts do
  endpoint 'accounts/create' do
    ensure! :a_bank_exists
  end
end
```

If the requirement has errors at the end of the execution, the error will be thrown and everything else will be canceled.
