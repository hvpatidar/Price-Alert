# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :alerts, only: [:index, :create, :destroy]
    end
  end
end