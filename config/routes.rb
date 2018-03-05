Rails.application.routes.draw do
  resources :wikis
  resources :charges, only: [:new, :create], path: "get-premium"

  devise_for :users
  
  resources :users do
    member do
      put :user_downgrade
    end
  end
  
  get 'get-premium' => 'charges#new'
  get 'about' => 'welcome#about'

  root 'welcome#index'
end
