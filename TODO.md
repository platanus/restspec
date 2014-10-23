- Allow type algebra in types definition.
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
- Find a way to modify the schema by endpoint
