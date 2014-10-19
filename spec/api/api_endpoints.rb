namespace :categories do
  schema :category

  endpoint :index do
    method :get
    path '/categories'
  end

  endpoint :create do
    method :post
    path '/categories'
  end
end

namespace :products do
  schema :product

  endpoint :index do
    method :get
    path '/products'
  end

  endpoint :create do
    method :post
    path '/products'
  end
end
