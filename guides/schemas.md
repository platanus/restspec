# Schemas DSL

## Top Level DSL

### schema

The `schema` method creates a schema with a name and yields a schema dsl.

```ruby
schema :book do
end
```

## Schema DSL

### attribute

The `attribute` method create an attribute inside a `schema`. Actually, a schema is a collection of attributes.

```ruby
schema :book do
  attribute :title, string
end
```

### Type methods

The type methods are shortcuts to create type declarations that decide how an attribute should generate examples and how the attribute can be validated  against a value. For more information for each one of them, please see the [types documentation](https://github.com/platanus/restspec/blob/master/docs/types.md).
