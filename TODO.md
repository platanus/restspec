1. Change `:type => :endpoint` to `:type => :endpoints`
2. Wrap this pattern:
    
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

3. The param for `be_like_schema` should default to the schema associated to the current namespace.
4. Research authentication strategies.
