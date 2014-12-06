resource :products do
  schema :product

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
  end
end
