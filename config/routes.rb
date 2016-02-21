Rails.application.routes.draw do
  resources :songs do
    member do
      post :upload
      post :generate_waveform
    end
    collection do
      post :pull
    end
  end
  resources :words, only: :update
end
