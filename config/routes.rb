Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, except: [:new] do
        resources :merchants, only: [:index], controller: 'item_merchants'
      end

      resources :merchants, except: [:new] do
        resources :items, only: [:index], controller: 'merchant_items'
      end
    end
  end
end
