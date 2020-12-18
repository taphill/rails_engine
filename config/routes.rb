Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :items do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end

      namespace :merchants do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
        get '/most_revenue', to: 'business_intelligence/revenue#index'
        get '/most_items', to: 'business_intelligence/items#index'
      end

      resources :items, except: [:new] do
        resources :merchants, only: [:index], controller: 'item_merchants'
      end

      resources :merchants, except: [:new] do
        resources :items, only: [:index], controller: 'merchant_items'
        get '/revenue', to: 'merchants/business_intelligence/revenue#show'
      end

      resources :revenue, only: [:index]
    end
  end
end
