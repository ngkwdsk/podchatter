Rails.application.routes.draw do
  devise_for :users
  root "podcast#index"
end
