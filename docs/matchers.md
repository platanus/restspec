# Matchers

## Have Status

Tests if the status is equals to a code of the underscored version of [his representation as symbols as they are found in Rails](http://futureshock-ed.com/2011/03/04/http-status-code-symbols-for-rails/).

```ruby
it { should have_status(:ok) }
it { should have_status(200) }
```

## Have Header

Tests if the response have the specified header.

```ruby
it { should have_header('Content-Type').equals('application/json') }
it { should have_header('Content-Type').that_contains('json') }
it { should have_header('Content-Type').that_matches(/json/) }
```

## Be Like Schema and Be Like Schema Array

Tests if the response's body obbeys to a format. They use the schema names used when defining schemas. The first parameter defaults to the schema name attached to the current endpoint.

```ruby
it { should be_like_schema(:book) }
it { should be_like_schema_array(:book) }
```

## Include Where

A not-so-important but helpful matcher to test if some condition applies to an array.

```ruby
it { should include_where -> person { person.email == 'email@example.com' } }
```

