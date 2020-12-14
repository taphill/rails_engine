Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, except: [:new]
      resources :merchants, only: [:index, :show]
    end
  end
end
