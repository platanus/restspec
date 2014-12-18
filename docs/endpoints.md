# Endpoints Full DSL

## Top Level DSL

### namespace

The `namespace` method creates a namespace for a set of endpoints, giving them a prefix in his names.

```ruby
namespace :animals do
  endpoint :show
  endpoint :update
end
```

### resource

The `resource` method creates a special namespace that has a `base_path` attribute set to his name. It can optionally receives a `base_path` option with a different path.

```ruby
resource :animals do
  endpoint :get
end

resource :light_sabers, base_path: '/light-sabers' do
  endpoint :get
end
```

It's important to note that the endpoints inside the `resource` block doesn't necessarily have the resource's namespace attached to them. For this to happen, we have to have the endpoints inside an `member` or `collection` method.

## Namespace DSL

### endpoint

The `endpoint` method only specifies a new endpoint. The block it yields (using the endpoint dsl) specifies how the endpoint is.

### member

Inside the `member` block inside a `resource`, you can specify a set of endpoints that inherits the `base_path` of the resource and the `/:id` string for the final url.

```ruby
resource :books do # /books
  member do # /books/:id
    endpoint :show # /books/:id. The name is: books/show
  end
end
```


### collection

Inside the `collection` method you can specify a set of endpoint that only inherits the `base_path`. It's useful to define resource collection actions, like typicals `create` or `index`.

```ruby
resource :books do # /books
  collection do # /books
    endpoint :create # /books
  end
end
```

### schema

You can attach a namespace to an schema. For example, you can attach the `book` schema to the `books` namespace because `book` related endpoints should be related to entities that conforms to the `book` schema. This is useful for some types, matchers and macros that can take adventage of this relationship.

```ruby
resource :books do
  schema :book
end
```

### all

The `all` method yields a block that will be executed in each endpoint defined.

```ruby
resource :books do
  all do
    method :get
  end

  endpoint :create # this will have the get method
  endpoint :index # this too
end
```

### url_param

This is just a proxy using `all`. This method calls the method `url_param` of each one of the endpoints with the given params. Please look at the `url_param` method of the Endpoints DSL.

### get, post, put, patch, delete, head

This methods are shortcuts for the following pattern:

```ruby
resource :books do
  endpoint :published do
    method :get
    path '/published'
  end
end

# shortcut:
resource :books do
  get :published, '/published'
end
```

## Endpoints DSL

### method

Defines what http method the endpoint holds.

```ruby
resource :books do
  collection do
    endpoint :index do
      method :get
    end
  end
end
```

### path

Defines what path the endpoint holds. By default, is empty.

```ruby
resource :books do
  collection do
    endpoint :published do
      method :get
      path '/published'
    end
  end
end
```

### schema

Attaches an schema to the endpoint. This provides some data for helpers, matchers and macros. If the endpoint's schema is nil, the endpoint's schema will be his namespace's schema.

```ruby
resource :books do
  collection do
    endpoint :published do
      method :get
      path '/published'
      schema :published_book
    end
  end
end
```

### headers

It is a hash that represents the endpoint headers. It can be modified to add new headers.

```ruby
resource :books do
  collection do
    endpoint :published do
      method :get
      path '/published'
      schema :published_book
      # Let's imagine this endpoint is going to a very weird system
      headers['Content-Type'] = 'application/json; charset=windows-1252'
    end
  end
end
```

### url_param

It fills a url parameter (the part of the path with a colon behind: `:id`, `:book_id`, etc) with the given value or block

```ruby
resource :books do
  member do
    endpoint :show do
      url_param(:id) { 998 }
      method :get
    end
  end
end
```

Or, using the shortcut for `get` requests:

```ruby
resource :books do
  member do
    get :show do
      url_param(:id) { 998 }
    end
  end
end
```
