Rails.application.routes.draw do
  resources :wikis
  resources :charges, only: [:new, :create], path: "get-premium"
  resources :collaborators, only: [:create, :destroy]

  devise_for :users

  resources :users, only: [] do
    member do
      put :user_downgrade
    end
  end

  resources :wikis, only: [] do
    resources :collaborators, only: [:create, :destroy]
  end

  get 'get-premium' => 'charges#new'
  get 'about' => 'welcome#about'

  root 'welcome#index'
end
