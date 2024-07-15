Rails.application.routes.draw do
  devise_for :users
  resources :podcasts do
    collection {get "search"}
  end
  root to: "podcasts#index"
end

