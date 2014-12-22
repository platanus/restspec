# Getting Started

### Create a Test API Project

```
$ restspec my-api-tests --api-prefix=http://my-api-domain/api/v1
$ cd my-api-tests
$ tree

.
├── Gemfile
├── Gemfile.lock
└── spec
    ├── api
    │   └── restspec
    │       ├── endpoints.rb
    │       ├── requirements.rb
    │       ├── schemas.rb
    │       └── restspec_config.rb
    ├── spec_helper.rb
    └── support
        ├── custom_macros.rb
        └── custom_matchers.rb

```

If you're familiar with the regular use of RSpec, this initial structure should look normal except for the files in the `api/restspec` folder.

- **endpoints.rb**: This is the place to describe your endpoints. One important thing is that your tests **won't define your endpoints**. In this way, we have a graph of the structure of your api *always* and this can help you to visualize your api structure and create better matchers.
- **schemas.rb**: The schemas are the shape of the resources you are manipulating in the api. It's a centralized place to put how your data should be.
- **requirements.rb**: The requirements are validations for the initial state of the api system. Testing that the user you are using exists on the api you are working on, testing that some read-only resources created outside of your control exists, etc.
- **restspec_config.rb**: This is where the configuration for Restspec resides. Here we will put some important things like headers that live in all the application and the url of the API to test.

### Setup

In the file `restspec_config.rb` you can change the basic url to use your api. Find the `Restspec`'s `configure` block and set the proper url:

```ruby
Restspec.configure do |config|
  config.base_url = 'http://my-api-domain/api/v2'
  # ...
end
```

### Usage

Anyway, we will add a first test. For this example, we will assume you have a regular api that consists on categories and products. First, we will add a test for the categories endpoints.

    $ touch spec/api/categories_spec.rb

In here, we will create a regular spec with a `describe` block with the `type` option set to `api`. Without the type, you won't get the matchers and macros that `api`-typed specs have.

```ruby
RSpec.describe :categories_api, :type => :api do

end
```

We want to begin testing the endpoint that creates a category. As said when describing the `endpoints.rb` file, we need to first define our endpoints in there. So, we will open our `endpoints.rb` file and add the following:

```ruby
namespace :categories do
  endpoint :create do
    path '/categories'
    method :post
  end
end
```

This creates an endpoint called `:create` that lives in the namespace `:categories`. Another way, more succint of define the same endpoint is to use the methods `resource` and `post`:

```ruby
resource :categories do
  post :create, '/categories'
end
```

If we use the `collection` method, we won't need to use the `/categories` argument. We can just do this:

```ruby
resource :categories do
  collection do
    post :create
  end
end
```

With this, we have our endpoint. To test this endpoint, just modify your `categories_spec.rb` file to add an endpoint declaration with a `test` block inside it:

```ruby
RSpec.describe :categories_api, :type => :api do
  endpoint 'categories/create' do
    test do
    end
  end
end
```

One important thing to note is that the endpoint is, under the hood, just a `describe` block attached to the endpoint object we just created before. The `test` method is like a context that executes the endpoint just **once** per `test` declaration, regardless of how many examples we have inside it.

Inside the test, we can use the [matchers](TODO) offered by Restspec. For example, we can test that the endpoint  returned `created`(201).

```ruby
RSpec.describe :categories_api, :type => :api do
  endpoint 'categories/create' do
    test do
      it { should have_status(:created) }
    end
  end
end
```

The output will be something like this:

```
categories_api
  [POST create]
    the happy path
      should have status :created
```

This is: A `test` declaration without a name is considered the *happy path*. Any other `test` block should behave like a context responsible for test another path.

If we run this test against a properly implemented api, you won't get 201 because you didn't specify a payload for the POST request. To specify a payload, we use the `payload` macro with a hash or a block that returns a hash:

```ruby
RSpec.describe :categories_api, :type => :api do
  endpoint 'categories/create' do
    test do
      payload name: 'Super Category'

      it { should have_status(:created) }
    end
  end
end
```

Altought this works, it won't scale with more complex structures and you have to decide what the data should be anytime. To help us with this troubles, we will define **schemas**.

Schemas are a representation of your data. They are responsible of two things: schema validation and examples generation. Edit your `schemas.rb` file like this:

```ruby
schema :category do
  attribute :name, string
end
```

This is your first schema and it looks straightforward. The `attribute` method defines an attribute with a name and a type. There are [more types than string](TODO) and they can be composed with other types to express some cases. For example, what if the category's name can be string or `null`?

For those cases, you can use the `|` operator, that acts like an `or` for types:

```ruby
schema :category do
  attribute :name, string | null
end
```

You can read more about types in [his detailed section](TODO).

With our first schema set, we can just express the payload in the test with the `schema_example` helper:

```ruby
RSpec.describe :categories_api, :type => :api do
  endpoint 'categories/create' do
    test do
      payload { schema_example :category }

      it { should have_status(:created) }
    end
  end
end
```

And we can test that the response's body obtained is a category using the `be_like_schema` matcher:

```ruby
RSpec.describe :categories_api, :type => :api do
  endpoint 'categories/create' do
    test do
      payload { schema_example :category }

      it { should have_status(:created) }
      it { should be_like_schema(:category) }
    end
  end
end
```


Because to define the `categories/create` endpoint we used the `resource` method and because the endpoint is called `categories`, the first argument for `schema_example` and `be_like_schema` will default to `:category`, so it's not really needed.

```ruby
RSpec.describe :categories_api, :type => :api do
  endpoint 'categories/create' do
    test do
      payload { schema_example :category }

      it { should have_status(:created) }
      it { should be_like_schema }
    end
  end
end
```

Say that you don't want to test only that the endpoint returned 201, but you want to be sure that the resource was *really* created. First, we need an endpoint to show a category in our `endpoints.rb` file:

```ruby
resource :categories do
  collection do
    post :create
  end

  member do
    get :show
  end
end
```

Because the `:show` endpoint is under a `member` declaration, his url is not only `/categories` but `/categories/:id`. In this way, we described a tipical resource endpoint.

We can use a new helper here called `read_endpoint` and use a standard RSpec test to test that the category was really created. We also use the `body` method to get the response's body and the `payload` method to get the payload used.

```ruby
RSpec.describe :categories_api, :type => :api do
  endpoint 'categories/create' do
    test do
      payload { schema_example }

      it { should have_status(:created) }
      it { should be_like_schema }

      it "created a category" do
        category = read_endpoint('categories/show', url_params: { id: body.id })
        expect(category.response).to have_status(:ok)
        expect(category.name).to eq(payload.name)
      end
    end
  end
end
```

As you can see, you can manipulate endpoints appart from his tests and this is nice because it allows us to use them for things like we have done before.

To test the `categories/show` endpoint, we face a tipical problem of API testing: `categories/show` needs an ID, but that ID depends on the `categories/create` endpoint or `categories/index` if you want to. Anyway, we don't want a callback hell formed from this dependencies.

A bad but possible solution would be to use the `url_params` macro to set params from reading the `categories/create` endpoint.

```ruby
endpoint `categories/show` do
  url_params { { id: read_endpoint('categories/create').id } }

  test do
    it { should have_status(:ok) }
    it { should be_like_schema }
  end
end
```

The drawback to this is that we can be putting more crap than needed onto the api database. Wouldn't it be nice if we can try first to get from some place and then, if we can't get from that other place, create something?

In the endpoint, we can define this:

```ruby
resource :categories do
  collection do
    post :create
  end

  member do
    url_param(:id) { schema_id(:category) }
    get :show
  end
end
```

The `url_param` method applies for all the endpoints inside `member` and they tie a url param (`:id`) to an schema type (we could use `integer` to generate a number). In this case we are using a very powerful type called `schema_id`, that generates examples based on the schema that he uses. It searches for endpoints attached to the `category` schema and looks for the endpoints called `index` and `create` to find the specific id. In this way, because the url parameter `:id` is filled by the example, we don't need to specify it. The test could only be like this:

```ruby
endpoint `categories/show` do
  test do
    it { should have_status(:ok) }
    it { should be_like_schema }
  end
end
```

And that's all. Under the hood, it will try to find the category for the endpoint from his dependencies. `SchemaId` is one example of what the separation between endpoints, schemas and tests can bring to api testing.

Anyway, we now may need a test for `categories/index`. It can be as easy as:

```ruby
# in the endpoints
resource :categories do
  collection do
    post :create
    get :index
  end

  member do
    url_param(:id) { schema_id(:category) }
    get :show
  end
end

# in the test
endpoint `categories/index` do
  test do
    it { should have_status(:ok) }
    it { should be_like_schema_array }
  end
end
```

Now, we should add tests for the products of the api. The endpoints should be as simple as the ones in `categories` so we will focus in the schemas. Our products have names, so they are simply like this:

```ruby
schema :product do
  attribute :name, string
end
```

The price usually it's a little bit tricky. Some apis may return a number and some other may return a string with the number. For both cases, we have two types: `decimal` and `decimal_string`. In this case we are going to just be lazy with the API and let the type be one of them.

```ruby
schema :product do
  attribute :name, string
  attribute :price, decimal | decimal_string
end
```

It's important to say that the first type in the operation is the one used when creating examples. In this case, the examples will generate a decimal.

The last attribute we need to define is the `category_id`. We should be tempted to use an integer but we have something better. A time ago, we talked about the `schema_id` type while defining how to fill the `id` url param of a member endpoint. Well, we can use it here again:

```ruby
schema :product do
  attribute :name, string
  attribute :price, decimal | decimal_string
  attribute :category_id, schema_id(:category)
end
```

And that's all. `be_like_schema` will try to match the id against one example from the `categories/index` endpoint and `schema_example` will generate a product with an `id` from that same endpoint or will create one using `categories/create`. Actually, this is a very repetitive pattern.

Finally, we will add the tests for the product api. Let's create `product_spec.rb` file and put some tests inside:

```ruby
RSpec.describe :products_api, :type => :api do
  endpoint 'products/create' do
    test do
      it { should have_status(:created) }
      it { should be_like_schema }

      it "created a product" do
        product = read_endpoint('products/show', url_params: { id: body.id })
        expect(product.response).to have_status(:ok)
        expect(product.id).to eq(payload.id)
      end
    end
  end

  endpoint 'products/show' do
    test do
      it { should have_status(:ok) }
      it { should be_like_schema }
    end
  end

  endpoint 'products/index' do
    test do
      it { should have_status(:ok) }
      it { should be_like_schema_array }
    end
  end
end
```

Now, we are going to add a `products/update` endpoint that should update the product using a `PUT`. This can be something like this:

```ruby
# endpoints.rb
resource :products do
  collection do
    post :create
    get :index
  end

  member do
    url_param(:id) { schema_id(:product) }

    get :show
    put :update
  end
end

# product_spec.rb
endpoint 'products/update' do
  test do
    payload { schema_example }

    it { should have_status :ok }
    it { should be_like_schema }

    it "updated the parameters" do
      product = read_endpoint('products/show', url_params: { id: body.id })
      expect(product).to include(payload)
    end
  end
end
```

Another way to test the `update` endpoint is to define an endpoint test as a resource related test. We can do it like this:

```ruby
endpoint 'products/update', resource: 'products/show' do

end
```

The `resource` keyword parameter is the endpoint we will use to load a resource instance. The main difference between a normal endpoint test and a resource one is that you have two resources: one before the request and one after that. The `products/show` endpoint should have an `url_param(:id)` set because because we will only execute it, and, without an `id`, we can't have an idea of what resource get. Well, with this new kind of test, we can do the following:

```ruby
endpoint 'products/update', resource: 'products/show' do
  payload do
    { name: "#{initial_resource.name}-modified" }
  end

  test do
    it 'updates the name' do
      expect(final_resource.name).to_not eq(initial_resource.name)
      expect(final_resource.name).to eq(request.payload.name)
    end

    it 'includes the payload' do
      expect(final_resource).to include(payload)
    end
  end
end
```


A `delete` endpoint should be something like this:


```ruby
# endpoints.rb
resource :products do
  collection do
    post :create
    get :index
  end

  member do
    url_param(:id) { schema_id(:product) }

    get :show
    put :update
    delete :destroy
  end
end

# product_spec.rb
endpoint 'products/destroy' do
  test do
    it { should have_status :no_content }

    it "deleted the product" do
      get_product = call_endpoint('products/show', url_params: {
        id: url_params.id
      })
      expect(get_product).to have_status(:not_found)
    end
  end
end
```

And that's all for this not-so-quick mini-tutorial about the usage of Restspec. We can improve more the code but it depends on you in most cases. You can make whatever you want. The most awesome thing about using RSpec is that, if you think that this tests are not DRY enough, you could simply use RSpec's shared examples, macros, helpers and matchers to make tests as concise as you want.
