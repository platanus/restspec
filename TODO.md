# Needed for 0.1

# Useful to Have (But they require more thoughts)
- `payload` will default to `schema_example` if not given based on the resource. (Maybe this should be optional)
- Find a way to modify the schema by endpoint.
- Research authentication strategies.
- Research pagination strategies and integrating them with `schema_id`.
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

# Pre-release Tasks
- Add tests for all the classes.
