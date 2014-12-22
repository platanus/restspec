# Helpers

## read_endpoint

It receives an endpoint name (in the form `namespace/endpoint`), and calls the endpoint returning the body of the call. It can receive the following options:

- **url_params:** (a hash)
- **body:** (a hash)
- **query_params:** (a hash)
- **merge_example_params:** (a boolean) This is useful to decide if we have to use the params (query and url ones) defined in an outer block and merge the with the params pased as arguments. By default is true)

```ruby
RSpec.describe :books do
  endpoint 'books/create' do
    payload { schema_example(:book) }

    test do
      it { should have_status(201) }

      it "actually creates a book" do
        book = read_endpoint('books/show', url_params: { id: body.id })
        expect(book).to be_present
        expect(book.id).to be_present
      end
    end
  end
end
```

## call_endpoint

It is the same as `read_endpoint` but instead of return the `body` of the response, it returns the response itself. It can be done to just call the response or to get the headers and status of the response.

## execute_endpoint!

This method re-executes the current endpoint. It exists just for extreme cases.

## schema_example

It receives a schema name and returns an example generated from the schema. Usually, the result is a hash. It should be used for payloads.
