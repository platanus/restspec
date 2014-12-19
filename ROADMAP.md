# For 0.1.x
- 100% Test coverage.
- Include Travis.
- Find a way to support a way of authentication based on cookies with an initial login.
- Find a way to avoid example value clashes when using resource tests.
- Schemas mixins or/and schemas inheritance.

# For 0.2 (They require more thoughts)
- Research pagination strategies and integrating them with `schema_id`.
- Research some way to generate markdown from a mix of the schemas and endpoints. (Like Apiary and others)
    + Generate whatever kind of markdown.
    + Generate Apiary Apib type.
    + Add a way to add texts to some points of the documentation.
    + TODO:
        * Untie Schema for Schema Response Body. DELETEs don't return string, they usually returns NO CONTENT. Indeed: nothing.
        * Allow using a TITLE.
