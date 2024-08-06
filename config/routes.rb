Rails.application.routes.draw do
  devise_for :users
  root to: "podcasts#index"
  resources :podcasts do
    resource :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
    collection do
    get :search
    end
    member do
    get :index_user
    end
  end
  resources :users do
    resource :relationships, only: [:create, :destroy]
  end
end

