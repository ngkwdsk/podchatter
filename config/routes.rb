Rails.application.routes.draw do
  devise_for :users
  resources :podcasts do
    collection do
    get :search
    post :create_from_search
    end
  end
  root to: "podcasts#index"
end

