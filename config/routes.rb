Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, except: [:new]
      resources :merchants, except: [:new] do
        resources :items, only: [:index], controller: 'merchants_items'
      end
    end
  end
end
