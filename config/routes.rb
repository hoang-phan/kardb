Rails.application.routes.draw do
  resources :songs do
    member do
      post :upload
    end
    collection do
      post :pull
    end
  end
  resources :words, only: :update
end
