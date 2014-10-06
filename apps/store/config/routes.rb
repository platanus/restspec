Rails.application.routes.draw do
  scope path: "/api/v1" do
    resources :categories, except: [:new, :edit]
    resources :products, except: [:new, :edit]
  end
end
