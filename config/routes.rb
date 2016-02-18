Rails.application.routes.draw do
  resources :songs do
    member do
      post :upload
    end
  end
  resources :words, only: :update
end
