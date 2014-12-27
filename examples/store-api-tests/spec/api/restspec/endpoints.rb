resource :products do
  collection do
    post :create do
      schema :product, :for => [:payload, :response]
    end

    get :index do
      schema :product, :for => [:response], :without => [:category]
    end
  end

  member do
    url_param(:id) { schema_id(:product) }

    get :show
    put :update
    delete(:destroy) { no_schema }
  end
end

resource :categories do
  schema :category

  collection do
    post :create
    get :index
  end

  member do
    url_param(:id) { schema_id(:category) }

    get :show
    put :update
    delete :destroy

    get :products, '/products' do
      schema :product
    end
  end
end
