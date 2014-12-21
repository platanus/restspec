# For 0.0.x
- 100% Test coverage.
- Find a way to avoid example value clashes when using resource tests.
- Document DateType and DateTimeType
- Divide the attachment between an endpoint and a schema, allowing to specify the role of the schema as a payload and the role of the schema as a response:
    + This should be something like this:
        ```ruby
        schema :product, :for => [:payload, :response]
        ```
    + When the schema is inherited from the namespace, the `:for` option will default to `[:response]`
    + The endpoint with a schema for payload will use this schema for the `payload` option for the endpoint.
    + The execution of the endpoint with an internal `payload` won't used the internal `payload` if an actual `payload` was passed as a parameter. The parameter will override the `payload`.
    + The endpoint with a schema for response will use the schema for matchers like `be_like_schema` and `be_like_schema_array`. Otherwise, it will not default to it.

# For 0.1 (They require more thoughts)
- Research pagination strategies and integrating them with `schema_id`.
- Provide a method for cookie-based authentication.
- Research some way to generate markdown from a mix of the schemas and endpoints. (Like Apiary and others)
    + Add a way to add texts to some points of the documentation.
    + TODO:
        * Untie Schema for Schema Response Body. DELETEs don't return string, they usually returns NO CONTENT. Indeed: nothing.
        * Find a way to add data to the schemas and endpoints for the documentation.
