- Refactor endpoints/namespace/resource structures to be more like a tree.
- Headers to reuse across many endpoints.
- `schema_example` macro first argument should default to the endpoint's schema name.
- Allow binding url and query params to types to get examples. `url_param(:id) { schema_id }`
- Wrap this pattern:
    
    ```ruby
    before(:all) do
      initial_products = read_endpoint
      if initial_products.size < 3
        3.times.map { read_endpoint('products/create', body: schema_example(:product)) }
      end
    end
    ```

    into this:

    ```ruby
    ensure_records 3
    ```

- The param for `be_like_schema` should default to the schema associated to the current namespace.
- Nested namespaces.
- Rename `namespace` to `resource` or create a `resource` method.
- Research authentication strategies.
- Research pagination strategies and integrating them with `schema_id`.
- Find a way to modify the schema by endpoint.
