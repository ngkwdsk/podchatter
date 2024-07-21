Rails.application.routes.draw do
  devise_for :users
  root to: "podcasts#index"
  resources :podcasts do
    resource :likes, only: [:create, :destroy]
    collection do
    get :search
    end
  end
end

